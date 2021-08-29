import 'package:flutter/material.dart';
import 'package:puzzlemath/math/challenge.dart';
import 'package:puzzlemath/math/math.dart';
import 'package:puzzlemath/widgets/challenge_list_item.dart';

class ChallengeListScreen extends StatelessWidget {
  final List<Challenge> challenges;

  ChallengeListScreen()
      : challenges = [
          Challenge(
              name: "What's the magic number?",
              solution: 1337,
              availableMarkers: [
                Marker.Digit1,
                Marker.Digit3,
                Marker.Digit3,
                Marker.Digit7
              ],
              state: ChallengeState.Solved),
          Challenge(
              name: "Child's play.",
              solution: 2,
              availableMarkers: [
                Marker.Digit1,
                Marker.Digit1,
                Marker.OperatorAdd
              ],
              state: ChallengeState.Unlocked),
          Challenge(
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
          Challenge(
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

  Widget buildChallengeItem(BuildContext context, int index) {
    final Challenge challenge = challenges[index];
    return ChallengeListItem(challenge);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Puzzle Programming'),
          centerTitle: true,
        ),
        body: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            thickness: 1.0,
            height: 1.0,
            color: Colors.black12,
          ),
          itemCount: challenges.length,
          itemBuilder: buildChallengeItem,
        ));
  }
}
