import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:puzzle_plugin/puzzle_plugin.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("can call native function", (WidgetTester tester) async {
    final buffer = ImageBuffer.empty();
    expect(PuzzlePlugin.detectObjects(buffer), []);
  });
}
