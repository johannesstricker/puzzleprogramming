import 'package:flutter_test/flutter_test.dart';
import 'package:puzzlemath/math/math.dart';

int? solveEquation(String equation) {
  final markers = stringToMarkers(equation);
  return parseEquation(markers)?.value();
}

void main() {
  test('stringToMarkers() parses a string into a list of markers', () {
    final markers = stringToMarkers('0123456789+-*/()!');
    expect(markers, [
      Marker.Digit0,
      Marker.Digit1,
      Marker.Digit2,
      Marker.Digit3,
      Marker.Digit4,
      Marker.Digit5,
      Marker.Digit6,
      Marker.Digit7,
      Marker.Digit8,
      Marker.Digit9,
      Marker.OperatorAdd,
      Marker.OperatorSubtract,
      Marker.OperatorMultiply,
      Marker.OperatorDivide,
      Marker.LeftParenthesis,
      Marker.RightParenthesis,
      Marker.Unknown,
    ]);
  });

  group('parseEquation() solves math equations', () {
    test('it solves math equations', () {
      expect(solveEquation('(10-1)/3'), 3);
      expect(solveEquation('10+9+52'), 71);
      expect(solveEquation('97-10'), 87);
      expect(solveEquation('2+7*3-10'), 13);
      expect(solveEquation('22*2/7'), 6);
      expect(solveEquation('(8+2)/2'), 5);
      expect(solveEquation('10*(4/2+8)'), 100);
      expect(solveEquation('5*(40/(2+2))'), 50);
    });
  });
}
