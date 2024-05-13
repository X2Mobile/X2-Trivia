import 'package:bloc/bloc.dart';
import 'package:x2trivia/app/screen/game/bloc/game_event.dart';
import 'package:x2trivia/app/screen/game/bloc/game_state.dart';
import 'package:x2trivia/domain/models/category.dart';
import 'package:x2trivia/domain/models/question.dart';
import 'package:x2trivia/domain/repositories/questions_repository.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    required this.questionsRepository,
    required this.category,
  }) : super(GameLoadInProgress(category: category)) {
    on<GameQuestionsRequested>(_onGameQuestionsRequested);
    on<GameAnswerSelect>(_onSelectAnswer);
    on<GameAnswerUnselect>(_onUnselectAnswer);
    on<GameValidateAnswerEvent>(_onGameValidateAnswerEvent);
    on<GameSubmitAnswerEvent>(_onGameSubmitAnswerEvent);
    add(GameQuestionsRequested(category: category));
  }

  final QuestionsRepository questionsRepository;
  final Category category;

  bool isLastQuestion(GameInProgress currentState) => currentState.questionIndex + 1 == currentState.questions.length;

  Future<void> _onGameQuestionsRequested(
    GameQuestionsRequested event,
    Emitter<GameState> emit,
  ) async {
    try {
      final List<Question> questions = await questionsRepository.getQuestions(category);

      emit(GameInProgress(category: category, questions: questions));
    } catch (error) {
      emit(GameLoadError(category: category, exception: error.toString()));
    }
  }

  void _onSelectAnswer(
      GameAnswerSelect event,
      Emitter<GameState> emit,
  ) {
    final currentState = state as GameInProgress;
    emit(currentState.copyWith(selectedAnswer: event.answer));
  }

  void _onUnselectAnswer(
      GameAnswerUnselect event,
      Emitter<GameState> emit,
  ) {
    final currentState = state as GameInProgress;
    emit(currentState.copyWith(selectedAnswer: null));
  }

  void _onGameValidateAnswerEvent(
    GameValidateAnswerEvent event,
    Emitter<GameState> emit,
  ) {
    final currentState = state as GameInProgress;
    final currentScore = currentState.score;
    final selectedAnswer = currentState.selectedAnswer;
    final correctAnswer = currentState.selectedAnswer!.isCorrect;
    emit(currentState.copyWith(score: correctAnswer ? currentScore + 1 : currentScore, revealAnswer: true, selectedAnswer: selectedAnswer));
  }

  void _onGameSubmitAnswerEvent(
    GameSubmitAnswerEvent event,
    Emitter<GameState> emit,
  ) {
    final currentState = state as GameInProgress;
    if (isLastQuestion(currentState)) {
      emit(GameEnded(category: category, score: currentState.score));
    } else {
      emit(currentState.copyWith(questionIndex: currentState.questionIndex + 1, revealAnswer: false, selectedAnswer: null));
    }
  }
}
