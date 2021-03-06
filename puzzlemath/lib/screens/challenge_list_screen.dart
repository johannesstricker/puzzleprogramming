import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzlemath/blocs/challenges/challenges.dart';
import 'package:puzzlemath/models/challenge/challenge.dart';
import 'package:puzzlemath/widgets/challenge_list_item.dart';

class ChallengeListScreen extends StatelessWidget {
  static const routeName = '/';

  final int progress;

  ChallengeListScreen({this.progress = 0});

  Widget buildChallengeItem(List<Challenge> challenges, int index) {
    final Challenge challenge = challenges[index];
    return ChallengeListItem(challenge);
  }

  Widget buildBody(BuildContext context) {
    return BlocBuilder<ChallengesBloc, ChallengesState>(
        builder: (context, state) {
      if (state is ChallengesLoading) {
        return Center(child: CircularProgressIndicator());
      }
      if (state is ChallengesError) {
        return Center(child: Text('An error occured.'));
      }
      final List<Challenge> challenges = (state as ChallengesLoaded).challenges;
      return ListView.separated(
        separatorBuilder: (context, index) => Divider(
          thickness: 1.0,
          height: 1.0,
          color: Colors.black12,
        ),
        itemCount: challenges.length,
        itemBuilder: (context, index) => buildChallengeItem(challenges, index),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Puzzle Programming'),
        centerTitle: true,
      ),
      body: buildBody(context),
    );
  }
}
