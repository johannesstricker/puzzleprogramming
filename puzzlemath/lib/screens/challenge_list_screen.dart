import 'package:flutter/material.dart';
import 'package:puzzlemath/math/challenge.dart';
import 'package:puzzlemath/math/challenge_repository.dart';
import 'package:puzzlemath/widgets/challenge_list_item.dart';

class ChallengeListScreen extends StatelessWidget {
  static const routeName = '/';

  final int progress;
  final List<Challenge> challenges = ChallengeRepository;

  ChallengeListScreen({this.progress = 0});

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
