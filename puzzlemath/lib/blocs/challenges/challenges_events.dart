abstract class ChallengesEvent {}

class LoadChallenges extends ChallengesEvent {
  @override
  String toString() => 'ChallengesLoadSuccess';
}
