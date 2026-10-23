import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/pantry/models/pantry_item.dart';
import '../models/app_notification_item.dart';

/// Central Notification Service for in-app alert center and OS push notifications.
class AppNotificationService {
  AppNotificationService._();
  static final AppNotificationService instance = AppNotificationService._();

  static const String _storageKey = 'shelf_chef_notifications_v1';
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final ValueNotifier<List<AppNotificationItem>> notifications =
      ValueNotifier<List<AppNotificationItem>>([]);
  final ValueNotifier<int> unreadCount = ValueNotifier<int>(0);

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    await _loadPersistedNotifications();
    await _initLocalNotifications();
  }

  Future<void> _initLocalNotifications() async {
    try {
      const initSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ),
        macOS: DarwinInitializationSettings(),
      );
      await _localNotifications.initialize(settings: initSettings);
      final androidPlatform = _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlatform?.requestNotificationsPermission();
    } catch (_) {}
  }

  Future<void> _showSystemNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          'shelf_chef_channel',
          'ShelfChef Kitchen Alerts',
          channelDescription:
              'Alerts for low stock, expiring food, and inventory updates',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
        macOS: DarwinNotificationDetails(),
      );
      await _localNotifications.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: details,
      );
    } catch (_) {}
  }

  Future<void> _loadPersistedNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(raw);
        notifications.value = decoded
            .map((e) => AppNotificationItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        _updateUnreadCount();
      }
    } catch (_) {}
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(
        notifications.value.map((e) => e.toJson()).toList(),
      );
      await prefs.setString(_storageKey, encoded);
    } catch (_) {}
  }

  void _updateUnreadCount() {
    unreadCount.value = notifications.value.where((n) => !n.isRead).length;
  }

  bool _hasRecentNotification(String title, String message, Duration window) {
    final now = DateTime.now();
    return notifications.value.any(
      (n) =>
          n.title == title &&
          n.message == message &&
          now.difference(n.timestamp) < window,
    );
  }

  Future<void> addNotification(
    AppNotificationItem item, {
    bool showSystem = true,
  }) async {
    final current = List<AppNotificationItem>.from(notifications.value);
    current.insert(0, item);
    if (current.length > 50) current.removeLast();
    notifications.value = current;
    _updateUnreadCount();
    await _saveToStorage();

    if (showSystem) {
      await _showSystemNotification(
        id: item.timestamp.millisecondsSinceEpoch.remainder(100000),
        title: item.title,
        body: item.message,
      );
    }
  }

  /// Triggered whenever a new item is added to the kitchen inventory.
  Future<void> notifyItemAdded({
    required String itemName,
    String? quantity,
    String? unit,
  }) async {
    final qtyStr = (quantity != null && quantity.isNotEmpty)
        ? ' ($quantity${unit != null && unit.isNotEmpty ? ' $unit' : ''})'
        : '';
    final item = AppNotificationItem(
      id: 'added_${DateTime.now().millisecondsSinceEpoch}',
      title: 'New Item Added',
      message: '$itemName$qtyStr was added to your pantry.',
      type: AppNotificationType.itemAdded,
      timestamp: DateTime.now(),
    );
    await addNotification(item, showSystem: true);
  }

  /// Triggered when an item quantity is running low.
  Future<void> notifyLowStock({
    required String itemName,
    required String quantity,
    required String unit,
    String? itemId,
  }) async {
    final title = 'Low Stock Alert';
    final message = '$itemName is running low ($quantity $unit left). Restock soon!';
    if (_hasRecentNotification(title, message, const Duration(hours: 6))) return;

    final item = AppNotificationItem(
      id: 'low_${itemId ?? itemName}_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      type: AppNotificationType.lowStock,
      timestamp: DateTime.now(),
      itemId: itemId,
    );
    await addNotification(item, showSystem: true);
  }

  /// Triggered when an item is going to expire within 1 day (or expired).
  Future<void> notifyExpiringSoon({
    required String itemName,
    required int daysUntilExpiry,
    String? itemId,
  }) async {
    final title = daysUntilExpiry <= 0 ? 'Food Expired' : 'Expiring in 1 Day';
    final message = daysUntilExpiry <= 0
        ? '$itemName has expired today! Consume or dispose of immediately.'
        : '$itemName expires in 1 day! Use it before it spoils.';

    if (_hasRecentNotification(title, message, const Duration(hours: 6))) return;

    final item = AppNotificationItem(
      id: 'exp_${itemId ?? itemName}_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      type: AppNotificationType.expiringSoon,
      timestamp: DateTime.now(),
      itemId: itemId,
    );
    await addNotification(item, showSystem: true);
  }

  /// Automatically scans pantry items and triggers notifications for low stock
  /// and items expiring within 1 day.
  Future<void> checkPantryAlerts(List<PantryItem> items) async {
    for (final item in items) {
      if (item.isExpiringWithin1Day || item.daysUntilExpiry <= 0) {
        await notifyExpiringSoon(
          itemName: item.name,
          daysUntilExpiry: item.daysUntilExpiry,
          itemId: item.id,
        );
      }
      if (item.isLowStock) {
        await notifyLowStock(
          itemName: item.name,
          quantity: item.quantity,
          unit: item.unit,
          itemId: item.id,
        );
      }
    }
  }

  Future<void> markAllAsRead() async {
    notifications.value =
        notifications.value.map((n) => n.copyWith(isRead: true)).toList();
    _updateUnreadCount();
    await _saveToStorage();
  }

  Future<void> markAsRead(String id) async {
    notifications.value = notifications.value
        .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
        .toList();
    _updateUnreadCount();
    await _saveToStorage();
  }

  Future<void> deleteNotification(String id) async {
    notifications.value =
        notifications.value.where((n) => n.id != id).toList();
    _updateUnreadCount();
    await _saveToStorage();
  }

  Future<void> clearAll() async {
    notifications.value = [];
    _updateUnreadCount();
    await _saveToStorage();
  }
}
