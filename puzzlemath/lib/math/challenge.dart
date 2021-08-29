import 'math.dart';

enum ChallengeState {
  Locked,
  Unlocked,
  Solved,
}

class Challenge {
  final String name;
  final int solution;
  final List<Marker>? availableMarkers;
  final ChallengeState state;

  Challenge(
      {required this.name,
      required this.solution,
      this.availableMarkers,
      this.state = ChallengeState.Locked});

  bool solve(MathEquation equation) {
    // TODO: check that only allowed markers were used
    return equation.value == solution;
  }
}
