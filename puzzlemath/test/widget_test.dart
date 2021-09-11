// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:puzzlemath/main.dart';
import 'package:puzzlemath/widgets/challenge_list_item.dart';

void main() {
  testWidgets('Shows a camera button', (WidgetTester tester) async {
    await tester.pumpWidget(CameraApp());
    expect(find.widgetWithText(ChallengeListItem, "What's the magic number?"),
        findsOneWidget);
  });
}
