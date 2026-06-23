import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Verify that GroceryApp is not null
    expect(const GroceryApp(), isNotNull);
  });
}
