import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_plugin/puzzle_plugin.dart';
import 'package:puzzlemath/math/math.dart';
import 'package:puzzlemath/blocs/challenge/challenge_events.dart';
import 'package:puzzlemath/blocs/challenge/challenge_states.dart';
import 'package:puzzlemath/models/challenge/challenge.dart';
import 'package:puzzlemath/config/navigation.dart';
import 'package:puzzlemath/screens/solution_screen.dart';
import 'package:puzzlemath/blocs/challenges/challenges.dart';
import 'package:rxdart/rxdart.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeBlocState> {
  final Challenge challenge;
  final ChallengesBloc challengesBloc;

  ChallengeBloc({
    required this.challenge,
    required this.challengesBloc,
  }) : super(ChallengeStarted()) {
    on<ImageReceived>(_onImageReceived,
        transformer: throttle(Duration(milliseconds: 100)));
  }

  EventTransformer<ImageReceived> throttle<ImageReceived>(Duration duration) {
    return (events, mapper) => events.throttleTime(duration).flatMap(mapper);
  }

  void _onImageReceived(
      ImageReceived event, Emitter<ChallengeBlocState> emit) async {
    if (state is ChallengeFailed || state is ChallengeSolved) {
      return;
    }

    final objects = await PuzzlePlugin.detectObjectsAsync(event.image);
    final sortedObjects = sortObjectListLTR(objects);

    // TODO: handle case with too many used markers
    final usedMarker =
        sortedObjects.map((object) => createMarker(object.id)).toList();
    if (usedMarker.length != challenge.availableMarkers.length) {
      emit(ChallengeAttempted(
          challenge: challenge, detectedObjects: sortedObjects));
      return;
    }

    try {
      int? proposedSolution = parseAbstractSyntaxTreeFromObjects(sortedObjects);
      if (challenge.checkSolution(proposedSolution, usedMarker)) {
        emit(ChallengeSolved(
            challenge: challenge, detectedObjects: sortedObjects));
        await Future.delayed(Duration(seconds: 2));

        challengesBloc.add(SolveChallenge(challenge));
        NavigatorKey.currentState?.pushNamed(
          SolutionScreen.routeName,
          arguments: SolutionScreenArguments(
            proposedSolution: proposedSolution!,
            usedMarkers: usedMarker,
            challenge: challenge,
          ),
        );

        return;
      }
    } catch (error) {
      debugPrint('Error while trying to parse syntax tree.');
    }
    emit(ChallengeFailed(challenge: challenge, detectedObjects: sortedObjects));
    await Future.delayed(Duration(seconds: 2));
    emit(ChallengeAttempted(
        challenge: challenge, detectedObjects: sortedObjects));
  }
}
