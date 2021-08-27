import 'math.dart';

class Challenge {
  final String name;
  final int solution;
  final List<Marker>? availableMarkers;

  Challenge(
      {required this.name, required this.solution, this.availableMarkers});

  bool solve(MathEquation equation) {
    // TODO: check that only allowed markers were used
    return equation.value == solution;
  }
}
