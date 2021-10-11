import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import './challenges_events.dart';
import './challenges_states.dart';
import 'package:puzzlemath/models/challenge/challenge.dart';
import 'package:puzzlemath/models/challenge/challenge_repository.dart';
import 'package:collection/collection.dart';
import 'package:puzzlemath/config/database.dart';

class ChallengesBloc extends Bloc<ChallengesEvent, ChallengesState> {
  late final ChallengeRepository _repository;

  ChallengesBloc() : super(ChallengesLoading()) {
    on<LoadChallenges>(_onLoadChallenges);
    on<SolveChallenge>(_onSolveChallenge);
    on<ResetProgress>(_onResetProgress);
    add(LoadChallenges());
  }

  void _onLoadChallenges(
      LoadChallenges event, Emitter<ChallengesState> emit) async {
    final databaseConnection = await Database.instance.connection;
    _repository = ChallengeRepository(databaseConnection);
    List<Challenge> challenges = await _repository.load();
    emit(ChallengesLoaded(challenges: challenges));
  }

  void _onSolveChallenge(
      SolveChallenge event, Emitter<ChallengesState> emit) async {
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
      await _repository.saveAll(updatedChallenges);
      emit(ChallengesLoaded(challenges: updatedChallenges));
    }
  }

  void _onResetProgress(
      ResetProgress event, Emitter<ChallengesState> emit) async {
    await _repository.reset();
    List<Challenge> challenges = await _repository.load();
    emit(ChallengesLoaded(challenges: challenges));
  }
}
