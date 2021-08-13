import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:puzzle_plugin/puzzle_plugin.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("tokenToString", (WidgetTester tester) async {
    expect(await PuzzlePlugin.tokenToString(1, 0), equals('+'));
    expect(await PuzzlePlugin.tokenToString(0, 9), equals('9'));
    expect(await PuzzlePlugin.tokenToString(5, 0), equals('('));
  });
}
