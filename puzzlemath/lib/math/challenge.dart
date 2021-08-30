import 'package:flutter/material.dart';
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
  final String name;
  final int solution;
  final List<Marker> availableMarkers;
  final String description;

  Challenge(
      {required this.name,
      required this.solution,
      required this.availableMarkers,
      this.description = DescriptionPlaceholder});

  bool checkSolution(int proposedSolution, List<Marker> usedMarkers) {
    Function eq = const UnorderedIterableEquality().equals;
    return eq(availableMarkers, usedMarkers) && proposedSolution == solution;
  }
}
