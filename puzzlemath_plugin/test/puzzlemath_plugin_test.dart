import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:puzzlemath_plugin/puzzlemath_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('puzzlemath_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await PuzzlemathPlugin.platformVersion, '42');
  });

  test('tokenToString', () async {
    expect(await PuzzlemathPlugin.tokenToString(0, 3), '3');
    expect(await PuzzlemathPlugin.tokenToString(1, 0), '+');
  });
}
