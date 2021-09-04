import 'package:bloc/bloc.dart';
import './challenges_events.dart';
import './challenges_states.dart';
import 'package:puzzlemath/math/challenge.dart';
import 'package:puzzlemath/math/challenge_repository.dart';

class ChallengesBloc extends Bloc<ChallengesEvent, ChallengesState> {
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
    yield ChallengesLoaded(challenges: ChallengeRepository);
  }

  Stream<ChallengesState> _mapSolveChallengeToState(
      SolveChallenge event) async* {
    if (state is ChallengesLoaded) {
      final updatedChallenges = (state as ChallengesLoaded)
          .challenges
          .map((challenge) => challenge == event.challenge
              ? challenge.copyWithState(ChallengeState.Solved)
              : challenge)
          .toList();
      yield ChallengesLoaded(challenges: updatedChallenges);
    }
  }
}
