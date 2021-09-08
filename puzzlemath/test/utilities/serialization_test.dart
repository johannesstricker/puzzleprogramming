import 'package:flutter_test/flutter_test.dart';
import 'package:puzzlemath/utilities/serialization.dart';
import 'package:puzzlemath/math/math.dart';

void main() {
  group('stringToEnum()', () {
    test('it converts a string to an enum', () {
      expect(stringToEnum('Marker.OperatorAdd', Marker.values),
          Marker.OperatorAdd);
    });

    test('it throws a StateError when no matching enum was found', () {
      expect(() => stringToEnum('Marker.OperatorUnknown', Marker.values),
          throwsA(isA<StateError>()));
    });
  });

  group('enumToString()', () {
    test('it returns a string representation of the enum value', () {
      expect(enumToString(Marker.OperatorSubtract), 'Marker.OperatorSubtract');
    });
  });

  test('stringToEnum() and enumToString() produce symmetric results', () {
    final stringRepresentation = enumToString(Marker.Digit7);
    expect(stringToEnum(stringRepresentation, Marker.values), Marker.Digit7);
  });

  group('jsonDecodeEnumList()', () {
    test('it converts a json string to a list of enum values', () {
      final String input =
          '["Marker.OperatorAdd", "Marker.Digit0", "Marker.Start"]';
      final List<Marker?> expectedOutput = [
        Marker.OperatorAdd,
        Marker.Digit0,
        Marker.Start
      ];
      expect(jsonDecodeEnumList(input, Marker.values), expectedOutput);
    });

    test('it throws a StateError when the json contains invalid enum strings',
        () {
      final String input = '["Marker.OperatorAdd", "Marker.Invalid"]';
      expect(() => jsonDecodeEnumList(input, Marker.values),
          throwsA(isA<StateError>()));
    });

    test('it throws a FormatException when the string is not valid json', () {
      final String input = '[Marker.OperatorAdd Marker.Invalid]';
      expect(() => jsonDecodeEnumList(input, Marker.values),
          throwsA(isA<FormatException>()));
    });
  });
}
