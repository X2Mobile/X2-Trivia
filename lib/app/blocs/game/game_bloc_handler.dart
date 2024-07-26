import 'package:bloc/bloc.dart';

import '../../../domain/models/question.dart';
import '../../../domain/repositories/questions_repository.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBlocHandler {
  final QuestionsRepository questionsRepository;

  GameBlocHandler({
    required this.questionsRepository,
  });

  bool isLastQuestion(GameInProgress currentState) => currentState.questionIndex + 1 == currentState.questions.length;

  Future<void> onGameQuestionsRequested(
      GameQuestionsRequested event,
      GameUninitialized state,
      Emitter<GameState> emit,
      ) async {
    try {
      emit(GameInitialFetching(category: event.category));
      final List<Question> questions = await questionsRepository.getQuestions(event.category);
      emit(GameInProgress(category: event.category, questions: questions));
    } catch (error) {
      emit(GameInitialFetchingError(exception: error.toString()));
      emit(const GameUninitialized());
    }
  }

  void onSelectAnswer(
    GameAnswerSelect event,
    GameInProgress state,
    Emitter<GameState> emit,
  ) =>
      emit(state.copyWith(selectedAnswer: event.answer));

  void onUnselectAnswer(
    GameAnswerUnselect event,
    GameInProgress state,
    Emitter<GameState> emit,
  ) =>
      emit(state.copyWith(selectedAnswer: null));

  void onGameValidateAnswerEvent(
    GameValidateAnswerEvent event,
    GameInProgress state,
    Emitter<GameState> emit,
  ) {
    final currentScore = state.score;
    final selectedAnswer = state.selectedAnswer;
    final correctAnswer = state.selectedAnswer!.isCorrect;
    emit(state.copyWith(score: correctAnswer ? currentScore + 1 : currentScore, revealAnswer: true, selectedAnswer: selectedAnswer));
  }

  void onGameSubmitAnswerEvent(
    GameSubmitAnswerEvent event,
    GameInProgress state,
    Emitter<GameState> emit,
  ) {
    if (isLastQuestion(state)) {
      emit(GameEnded(category: state.category, score: state.score, questions: state.questions));
    } else {
      emit(state.copyWith(questionIndex: state.questionIndex + 1, revealAnswer: false, selectedAnswer: null));
    }
  }

  void onGamePaused(
    GamePause event,
    GameInProgress state,
    Emitter<GameState> emit,
  ) {
    emit(
      GamePaused(
        category: state.category,
        questions: state.questions,
        questionIndex: state.questionIndex,
        score: state.score,
        revealAnswer: state.revealAnswer,
        selectedAnswer: state.selectedAnswer,
      ),
    );
  }

  void onGameResume(
    GameResume event,
    GamePaused state,
    Emitter<GameState> emit,
  ) {
    emit(
      GameInProgress(
        category: state.category,
        questions: state.questions,
        questionIndex: state.questionIndex + (state.revealAnswer ? 1 : 0),
        score: state.score,
        revealAnswer: false,
      ),
    );
  }
}
