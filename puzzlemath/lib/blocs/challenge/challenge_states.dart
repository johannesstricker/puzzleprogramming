import 'package:puzzle_plugin/puzzle_plugin.dart';
import 'package:puzzlemath/math/math.dart';
import 'package:puzzlemath/models/challenge/challenge.dart';

abstract class ChallengeBlocState {}

class ChallengeStarted extends ChallengeBlocState {
  @override
  String toString() => 'ChallengeStarted';
}

class ChallengeAttempted extends ChallengeBlocState {
  final Challenge challenge;
  final List<DetectedObject> detectedObjects;
  final List<Marker> usedMarkers;

  ChallengeAttempted({
    required this.detectedObjects,
    required this.challenge,
    required this.usedMarkers,
  });

  List<Marker> getUsedMarkersPadded(int length) {
    return List<Marker>.generate(length, (index) {
      final detectedMarker =
          index < usedMarkers.length ? usedMarkers[index] : Marker.Unknown;
      return detectedMarker;
    });
  }

  @override
  String toString() => 'ChallengeAttempted';
}

class ChallengeSolved extends ChallengeAttempted {
  ChallengeSolved({
    required Challenge challenge,
    required List<DetectedObject> detectedObjects,
    required List<Marker> usedMarkers,
  }) : super(
            challenge: challenge,
            detectedObjects: detectedObjects,
            usedMarkers: usedMarkers);

  @override
  String toString() => 'ChallengeSolved';
}

class ChallengeFailed extends ChallengeAttempted {
  ChallengeFailed({
    required Challenge challenge,
    required List<DetectedObject> detectedObjects,
    required List<Marker> usedMarkers,
  }) : super(
            challenge: challenge,
            detectedObjects: detectedObjects,
            usedMarkers: usedMarkers);

  @override
  String toString() => 'ChallengeFailed';
}
