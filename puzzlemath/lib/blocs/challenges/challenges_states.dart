import 'package:puzzlemath/models/challenge/challenge.dart';

abstract class ChallengesState {}

class ChallengesLoading extends ChallengesState {
  @override
  String toString() => 'ChallengesLoading';
}

class ChallengesLoaded extends ChallengesState {
  List<Challenge> challenges;

  ChallengesLoaded({required this.challenges});

  @override
  String toString() => 'ChallengesLoaded';

  double get progress {
    int solvedCount = challenges
        .where((challenge) => challenge.state == ChallengeState.Solved)
        .length;
    return solvedCount.toDouble() / challenges.length.toDouble();
  }
}

class ChallengesError extends ChallengesState {
  @override
  String toString() => 'ChallengesError';
}
