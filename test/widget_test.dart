import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_chef_app/main.dart';

void main() {
  testWidgets('ShelfChefApp loads successfully test', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ShelfChefApp());

    // Verify that app starts up without crashing.
    expect(find.byType(ShelfChefApp), findsOneWidget);
  });
}
