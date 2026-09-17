import 'package:flutter_test/flutter_test.dart';
import 'package:himopay/main.dart';

void main() {
  testWidgets('Himo Pay app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HimoPayApp());
    expect(find.byType(HimoPayApp), findsOneWidget);
    // Advance time for splash screen timer to resolve cleanly
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
  });
}
