import 'dart:ui';

abstract class ChallengeEvent {}

class ImageReceived extends ChallengeEvent {
  final Image image;
  ImageReceived(this.image);

  @override
  String toString() => 'AttemptChallenge';
}
