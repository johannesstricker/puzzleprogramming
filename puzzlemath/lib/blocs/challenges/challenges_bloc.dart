import 'package:bloc/bloc.dart';
import './challenges_events.dart';
import './challenges_states.dart';
import 'package:puzzlemath/models/challenge/challenge.dart';
import 'package:puzzlemath/models/challenge/challenge_repository.dart';
import 'package:collection/collection.dart';

class ChallengesBloc extends Bloc<ChallengesEvent, ChallengesState> {
  late final ChallengeRepository _repository;

  ChallengesBloc() : super(ChallengesLoading()) {
    add(LoadChallenges());
  }

  @override
  Stream<ChallengesState> mapEventToState(ChallengesEvent event) async* {
    if (event is LoadChallenges) {
      yield* _mapLoadChallengesToState();
    } else if (event is SolveChallenge) {
      yield* _mapSolveChallengeToState(event);
    }
  }

  Stream<ChallengesState> _mapLoadChallengesToState() async* {
    _repository = await ChallengeRepository.connected();
    final challenges = await _repository.seed();
    yield ChallengesLoaded(challenges: challenges);
  }

  Stream<ChallengesState> _mapSolveChallengeToState(
      SolveChallenge event) async* {
    if (state is ChallengesLoaded) {
      final unlockedChallengeIndex =
          (state as ChallengesLoaded).challenges.indexOf(event.challenge) + 1;
      final updatedChallenges =
          (state as ChallengesLoaded).challenges.mapIndexed((index, challenge) {
        if (challenge == event.challenge) {
          return challenge.copyWithState(ChallengeState.Solved);
        } else if (index == unlockedChallengeIndex) {
          return challenge.state == ChallengeState.Locked
              ? challenge.copyWithState(ChallengeState.Unlocked)
              : challenge;
        }
        return challenge;
      }).toList();
      yield ChallengesLoaded(challenges: updatedChallenges);
    }
  }
}
