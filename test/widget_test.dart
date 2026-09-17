import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:himopay/main.dart';
import 'package:himopay/core/storage/app_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await AppPreferences.init();
  });

  testWidgets('Himo Pay app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HimoPayApp());
    expect(find.byType(HimoPayApp), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
  });
}
