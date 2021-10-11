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

  ChallengeAttempted({
    required this.detectedObjects,
    required this.challenge,
  });

  get usedMarkers {
    return detectedObjects.map((object) => createMarker(object.id)).toList();
  }

  List<Marker> getUsedMarkersPadded(int length) {
    return List<Marker>.generate(length, (index) {
      final detectedMarker = index < detectedObjects.length
          ? createMarker(detectedObjects[index].id)
          : Marker.Unknown;
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
  }) : super(challenge: challenge, detectedObjects: detectedObjects);

  @override
  String toString() => 'ChallengeSolved';
}

class ChallengeFailed extends ChallengeAttempted {
  ChallengeFailed({
    required Challenge challenge,
    required List<DetectedObject> detectedObjects,
  }) : super(challenge: challenge, detectedObjects: detectedObjects);

  @override
  String toString() => 'ChallengeFailed';
}
