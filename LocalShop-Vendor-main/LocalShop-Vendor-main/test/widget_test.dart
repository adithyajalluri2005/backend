import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/main.dart';

void main() {
  testWidgets('renders splash screen shell', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: VendorApp()));
    await tester.pumpAndSettle();

    expect(find.text('NearBuy\nPartner'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
