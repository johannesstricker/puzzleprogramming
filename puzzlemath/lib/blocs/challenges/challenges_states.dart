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
}

class ChallengesError extends ChallengesState {
  @override
  String toString() => 'ChallengesError';
}
