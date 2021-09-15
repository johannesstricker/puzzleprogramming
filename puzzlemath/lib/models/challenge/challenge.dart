import 'package:collection/collection.dart';
import 'package:puzzlemath/utilities/serialization.dart';
import 'package:puzzlemath/math/math.dart';
import 'package:equatable/equatable.dart';

enum ChallengeState {
  Locked,
  Unlocked,
  Solved,
}

const String DescriptionPlaceholder =
    'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.';

class Challenge extends Equatable {
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

  Challenge copyWithState(ChallengeState newState) {
    return Challenge(
      id,
      name: name,
      solution: solution,
      availableMarkers: availableMarkers,
      description: description,
      state: newState,
    );
  }

  bool checkSolution(int proposedSolution, List<Marker> usedMarkers) {
    Function eq = const UnorderedIterableEquality().equals;
    return eq(availableMarkers, usedMarkers) && proposedSolution == solution;
  }

  @override
  List<Object> get props => [id];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'solution': solution,
      'description': description,
      'state': enumToString(state),
      'markers': jsonEncodeEnumList(availableMarkers),
    };
  }

  factory Challenge.fromMap(Map<String, dynamic> input) {
    return Challenge(
      input['id'],
      name: input['name'],
      description: input['description'],
      solution: input['solution'],
      state: stringToEnum(input['state'], ChallengeState.values),
      availableMarkers: jsonDecodeEnumList(input['markers'], Marker.values),
    );
  }
}
