import 'package:flutter_test/flutter_test.dart';
import 'package:country_meat_porter/app.dart';

void main() {
  testWidgets('App initialization smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CountryMeatPorterApp());
    await tester.pump(const Duration(seconds: 3));
    expect(find.byType(CountryMeatPorterApp), findsOneWidget);
  });
}
