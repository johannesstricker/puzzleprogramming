import 'package:bloc/bloc.dart';
import './challenges_events.dart';
import './challenges_states.dart';
import 'package:puzzlemath/math/challenge_repository.dart';

class ChallengesBloc extends Bloc<ChallengesEvent, ChallengesState> {
  ChallengesBloc() : super(ChallengesLoading()) {
    add(LoadChallenges());
  }

  @override
  Stream<ChallengesState> mapEventToState(ChallengesEvent event) async* {
    if (event is LoadChallenges) {
      yield* _mapLoadChallengesToState();
    }
  }

  Stream<ChallengesState> _mapLoadChallengesToState() async* {
    yield ChallengesLoaded(challenges: ChallengeRepository);
  }
}
