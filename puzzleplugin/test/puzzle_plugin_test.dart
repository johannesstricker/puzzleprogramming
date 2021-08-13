import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle_plugin/puzzle_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('puzzle_plugin');

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
    expect(await PuzzlePlugin.platformVersion, '42');
  });

  test('tokenToString', () async {
    expect(await PuzzlePlugin.tokenToString(0, 3), '3');
    expect(await PuzzlePlugin.tokenToString(1, 0), '+');
  });
}
