import 'package:flutter/material.dart';
import 'package:puzzlemath/math/challenge.dart';
import 'package:puzzlemath/math/math.dart';
import 'package:puzzlemath/widgets/challenge_list_item.dart';

class ChallengeListScreen extends StatelessWidget {
  static const routeName = '/';

  final int progress;
  final List<Challenge> challenges;

  ChallengeListScreen({this.progress = 0})
      : challenges = [
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

  Widget buildChallengeItem(BuildContext context, int index) {
    final Challenge challenge = challenges[index];
    ChallengeState state = ChallengeState.Locked;
    if (progress > index) {
      state = ChallengeState.Solved;
    } else if (progress == index) {
      state = ChallengeState.Unlocked;
    }
    return ChallengeListItem(challenge, state: state);
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
