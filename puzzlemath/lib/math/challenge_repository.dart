import 'package:puzzlemath/math/challenge.dart';
import 'package:puzzlemath/math/math.dart';

const List<Challenge> ChallengeRepository = [
  Challenge(0,
      name: "What's the magic number?",
      solution: 137,
      availableMarkers: [Marker.Digit1, Marker.Digit3, Marker.Digit7]),
  Challenge(
    1,
    name: "Child's play.",
    solution: 2,
    availableMarkers: [
      Marker.Digit1,
      Marker.Digit1,
      Marker.OperatorAdd,
    ],
  ),
  Challenge(2,
      name: 'Easy peasy, lemon squeezy!',
      solution: 28,
      availableMarkers: [
        Marker.Digit2,
        Marker.Digit0,
        Marker.OperatorAdd,
        Marker.Digit1,
        Marker.Digit2,
        Marker.OperatorSubtract,
        Marker.Digit4
      ]),
  Challenge(3,
      name: "Let's turn these numbers up!",
      solution: 999,
      availableMarkers: [
        Marker.Digit3,
        Marker.Digit3,
        Marker.Digit3,
        Marker.Digit3,
        Marker.OperatorMultiply,
      ]),
];
