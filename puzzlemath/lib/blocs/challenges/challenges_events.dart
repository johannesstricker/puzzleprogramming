import 'package:puzzlemath/math/challenge.dart';

abstract class ChallengesEvent {}

class LoadChallenges extends ChallengesEvent {
  @override
  String toString() => 'ChallengesLoadSuccess';
}

class SolveChallenge extends ChallengesEvent {
  final Challenge challenge;

  SolveChallenge(this.challenge);

  @override
  String toString() => 'SolveChallenge';
}
