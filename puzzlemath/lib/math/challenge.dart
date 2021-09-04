import 'package:collection/collection.dart';
import 'math.dart';

enum ChallengeState {
  Locked,
  Unlocked,
  Solved,
}

const String DescriptionPlaceholder =
    'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.';

class Challenge {
  final int id;
  final String name;
  final int solution;
  final List<Marker> availableMarkers;
  final String description;
  final ChallengeState state;

  const Challenge(this.id,
      {required this.name,
      required this.solution,
      required this.availableMarkers,
      this.state = ChallengeState.Locked,
      this.description = DescriptionPlaceholder});

  bool checkSolution(int proposedSolution, List<Marker> usedMarkers) {
    Function eq = const UnorderedIterableEquality().equals;
    return eq(availableMarkers, usedMarkers) && proposedSolution == solution;
  }
}
