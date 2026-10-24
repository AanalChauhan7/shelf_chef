import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelf_chef_app/core/core.dart';
import 'package:shelf_chef_app/features/dashboard/widgets/alert_notification_tile.dart';
import 'package:shelf_chef_app/features/dashboard/widgets/alerts_modal.dart';
import 'package:shelf_chef_app/features/dashboard/widgets/dashboard_header.dart';
import 'package:shelf_chef_app/features/pantry/models/pantry_item.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await AppNotificationService.instance.init();
    await AppNotificationService.instance.clearAll();
  });

  group('PantryItem Expiry & Low Stock Properties Tests', () {
    test('isExpiringWithin1Day returns true for items expiring in 0 or 1 day', () {
      final now = DateTime.now();
      final itemToday = PantryItem(
        id: '1',
        name: 'Whole Milk',
        quantity: '2',
        expiryDate: DateTime(now.year, now.month, now.day),
      );
      final itemTomorrow = PantryItem(
        id: '2',
        name: 'Fresh Bread',
        quantity: '1',
        expiryDate: DateTime(now.year, now.month, now.day).add(const Duration(days: 1)),
      );
      final itemNextWeek = PantryItem(
        id: '3',
        name: 'Apples',
        quantity: '4',
        expiryDate: DateTime(now.year, now.month, now.day).add(const Duration(days: 7)),
      );

      expect(itemToday.isExpiringWithin1Day, isTrue);
      expect(itemTomorrow.isExpiringWithin1Day, isTrue);
      expect(itemNextWeek.isExpiringWithin1Day, isFalse);
    });

    test('isLowStock detects items with quantity <= 1 or <= 250g', () {
      final lowPcs = PantryItem(id: '1', name: 'Eggs', quantity: '1', unit: 'pcs');
      final highPcs = PantryItem(id: '2', name: 'Eggs', quantity: '12', unit: 'pcs');
      final lowGram = PantryItem(id: '3', name: 'Butter', quantity: '150', unit: 'g');
      final highGram = PantryItem(id: '4', name: 'Flour', quantity: '1000', unit: 'g');
      final lowKg = PantryItem(id: '5', name: 'Rice', quantity: '0.5', unit: 'kg');

      expect(lowPcs.isLowStock, isTrue);
      expect(highPcs.isLowStock, isFalse);
      expect(lowGram.isLowStock, isTrue);
      expect(highGram.isLowStock, isFalse);
      expect(lowKg.isLowStock, isTrue);
    });
  });

  group('AppNotificationItem Model Tests', () {
    test('serialization and deserialization preserves all fields', () {
      final item = AppNotificationItem(
        id: 'test_1',
        title: 'Low Stock Alert',
        message: 'Tomatoes running low',
        type: AppNotificationType.lowStock,
        timestamp: DateTime(2026, 10, 23, 12, 0),
        isRead: false,
        itemId: 'item_100',
      );

      final json = item.toJson();
      final fromJson = AppNotificationItem.fromJson(json);

      expect(fromJson.id, equals(item.id));
      expect(fromJson.title, equals(item.title));
      expect(fromJson.message, equals(item.message));
      expect(fromJson.type, equals(AppNotificationType.lowStock));
      expect(fromJson.isRead, isFalse);
      expect(fromJson.itemId, equals('item_100'));
    });

    test('timeAgo returns formatted relative time', () {
      final now = DateTime.now();
      final justNow = AppNotificationItem(
        id: '1',
        title: 'T',
        message: 'M',
        type: AppNotificationType.general,
        timestamp: now.subtract(const Duration(seconds: 15)),
      );
      final minutesAgo = AppNotificationItem(
        id: '2',
        title: 'T',
        message: 'M',
        type: AppNotificationType.general,
        timestamp: now.subtract(const Duration(minutes: 5)),
      );

      expect(justNow.timeAgo, equals('Just now'));
      expect(minutesAgo.timeAgo, equals('5m ago'));
    });
  });

  group('AppNotificationService Logic Tests', () {
    test('notifyItemAdded inserts new item notification and increments unreadCount', () async {
      expect(AppNotificationService.instance.unreadCount.value, equals(0));

      await AppNotificationService.instance.notifyItemAdded(
        itemName: 'Amul Butter',
        quantity: '500',
        unit: 'g',
      );

      expect(AppNotificationService.instance.notifications.value.length, equals(1));
      expect(AppNotificationService.instance.unreadCount.value, equals(1));
      final notification = AppNotificationService.instance.notifications.value.first;
      expect(notification.type, equals(AppNotificationType.itemAdded));
      expect(notification.message, contains('Amul Butter (500 g)'));
    });

    test('notifyLowStock and notifyExpiringSoon create appropriate notifications', () async {
      await AppNotificationService.instance.notifyLowStock(
        itemName: 'Onions',
        quantity: '1',
        unit: 'kg',
      );
      await AppNotificationService.instance.notifyExpiringSoon(
        itemName: 'Yogurt',
        daysUntilExpiry: 1,
      );

      final items = AppNotificationService.instance.notifications.value;
      expect(items.length, equals(2));
      expect(items.any((n) => n.type == AppNotificationType.lowStock), isTrue);
      expect(items.any((n) => n.type == AppNotificationType.expiringSoon), isTrue);
    });

    test('checkPantryAlerts scans list and notifies for both low stock and 1-day expiry', () async {
      final now = DateTime.now();
      final pantry = [
        PantryItem(
          id: 'item_1',
          name: 'Fresh Spinach',
          quantity: '1',
          unit: 'pack',
          expiryDate: DateTime(now.year, now.month, now.day).add(const Duration(days: 1)),
        ),
        PantryItem(
          id: 'item_2',
          name: 'Basmati Rice',
          quantity: '5',
          unit: 'kg',
          expiryDate: DateTime(now.year, now.month, now.day).add(const Duration(days: 60)),
        ),
      ];

      await AppNotificationService.instance.checkPantryAlerts(pantry);

      final notifications = AppNotificationService.instance.notifications.value;
      // Spinach should trigger both expiringSoon (1 day) and lowStock (quantity == 1)
      expect(notifications.any((n) => n.title.contains('Expiring')), isTrue);
      expect(notifications.any((n) => n.title.contains('Low Stock')), isTrue);
      // Rice has 5kg and 60 days, should not trigger alerts
      expect(notifications.any((n) => n.message.contains('Basmati Rice')), isFalse);
    });

    test('markAsRead, markAllAsRead, and deleteNotification manage notification states', () async {
      await AppNotificationService.instance.notifyItemAdded(itemName: 'Item A');
      await AppNotificationService.instance.notifyItemAdded(itemName: 'Item B');

      expect(AppNotificationService.instance.unreadCount.value, equals(2));

      final firstId = AppNotificationService.instance.notifications.value.first.id;
      await AppNotificationService.instance.markAsRead(firstId);
      expect(AppNotificationService.instance.unreadCount.value, equals(1));

      await AppNotificationService.instance.markAllAsRead();
      expect(AppNotificationService.instance.unreadCount.value, equals(0));

      await AppNotificationService.instance.deleteNotification(firstId);
      expect(AppNotificationService.instance.notifications.value.length, equals(1));

      await AppNotificationService.instance.clearAll();
      expect(AppNotificationService.instance.notifications.value, isEmpty);
    });
  });

  group('Notification UI Widgets Tests', () {
    testWidgets('AlertNotificationTile renders notification details and triggers callbacks', (tester) async {
      bool tapped = false;
      bool deleted = false;

      final item = AppNotificationItem(
        id: '1',
        title: 'Low Stock Alert',
        message: 'Milk is running low (1 L left).',
        type: AppNotificationType.lowStock,
        timestamp: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AlertNotificationTile(
              item: item,
              isDark: false,
              onTap: () => tapped = true,
              onDelete: () => deleted = true,
            ),
          ),
        ),
      );

      expect(find.text('Low Stock Alert'), findsOneWidget);
      expect(find.text('Milk is running low (1 L left).'), findsOneWidget);
      expect(find.byIcon(Icons.production_quantity_limits_rounded), findsOneWidget);

      await tester.tap(find.text('Low Stock Alert'));
      expect(tapped, isTrue);

      await tester.tap(find.byIcon(Icons.close_rounded));
      expect(deleted, isTrue);
    });

    testWidgets('DashboardHeader notification bell displays badge when unreadCount > 0', (tester) async {
      await AppNotificationService.instance.clearAll();
      await AppNotificationService.instance.notifyItemAdded(itemName: 'Bread');
      await AppNotificationService.instance.notifyItemAdded(itemName: 'Butter');

      expect(AppNotificationService.instance.unreadCount.value, equals(2));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DashboardHeader(
              userName: 'Chef Gordon',
              onOpenAlerts: () {},
              onOpenProfile: () {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('AlertsDialog displays live notifications and empty state', (tester) async {
      await AppNotificationService.instance.clearAll();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AlertsDialog(isDark: false),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('All caught up!'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);

      await AppNotificationService.instance.notifyExpiringSoon(
        itemName: 'Milk',
        daysUntilExpiry: 1,
      );

      await tester.pumpAndSettle();
      expect(find.text('Expiring in 1 Day'), findsOneWidget);
      expect(find.text('Clear All'), findsOneWidget);
      expect(find.text('Mark as Read'), findsOneWidget);
    });
  });
}
