import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_chef_app/features/dashboard/widgets/budget_card.dart';

void main() {
  group('BudgetCard Overflow and Responsiveness Tests', () {
    testWidgets('BudgetCard with exceeded budget renders without overflow on 360x640 screen', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: BudgetCard(
                spentAmount: 8500.0,
                totalBudget: 6000.0,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Monthly Budget'), findsOneWidget);
      expect(find.text('₹2500 Over'), findsOneWidget);
      expect(find.text('Budget exceeded by ₹2500!'), findsOneWidget);
    });

    testWidgets('BudgetCard with exceeded budget renders without overflow on 320x568 screen', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: BudgetCard(
                spentAmount: 25000.0,
                totalBudget: 6000.0,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Monthly Budget'), findsOneWidget);
      expect(find.text('₹19000 Over'), findsOneWidget);
    });

    testWidgets('BudgetCard within budget limit renders properly on 320x568 screen', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: BudgetCard(
                spentAmount: 3200.0,
                totalBudget: 6000.0,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Monthly Budget'), findsOneWidget);
      expect(find.text('₹2800 Left'), findsOneWidget);
      expect(find.text('Within monthly budget limit'), findsOneWidget);
    });
  });
}
