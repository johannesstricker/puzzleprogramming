import 'math.dart';

enum ChallengeState {
  Locked,
  Unlocked,
  Solved,
}

const String DescriptionPlaceholder =
    'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.';

class Challenge {
  final String name;
  final int solution;
  final List<Marker>? availableMarkers;
  final ChallengeState state;
  final String description;

  Challenge(
      {required this.name,
      required this.solution,
      this.availableMarkers,
      this.state = ChallengeState.Locked,
      this.description = DescriptionPlaceholder});

  bool solve(MathEquation equation) {
    // TODO: check that only allowed markers were used
    return equation.value == solution;
  }
}
