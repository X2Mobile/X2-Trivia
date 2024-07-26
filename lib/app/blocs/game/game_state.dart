import 'package:equatable/equatable.dart';
import 'package:x2trivia/domain/models/answer.dart';
import 'package:x2trivia/domain/models/category.dart';
import 'package:x2trivia/domain/models/question.dart';

sealed class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

//Uninitialized
class GameUninitialized extends GameState {

  @override
  List<Object?> get props => [];

  const GameUninitialized();
}

class GameInitialFetching extends GameState {
  const GameInitialFetching({required this.category});

  final Category category;

  @override
  List<Object?> get props => [category];
}

class GameInitialFetchingError extends GameState {
  const GameInitialFetchingError({required this.exception});

  final String exception;

  @override
  List<Object?> get props => [];
}

//Initialized
abstract class GameInitialized extends GameState {
  const GameInitialized({
    required this.questions,
    required this.category,
  });

  final List<Question> questions;
  final Category category;

  @override
  List<Object?> get props => [questions, category];
}

abstract class GameActive extends GameInitialized {
  const GameActive({
    required super.questions,
    required super.category,
    this.questionIndex = 0,
    this.score = 0,
    this.revealAnswer = false,
    this.selectedAnswer,
  });

  final int questionIndex;
  final int score;
  final bool revealAnswer;
  final Answer? selectedAnswer;

  @override
  List<Object?> get props => [
    ...super.props,
    questionIndex,
    score,
    revealAnswer,
    selectedAnswer,
  ];
}

class GameInProgress extends GameActive {
  const GameInProgress({
    required super.questions,
    required super.category,
    super.questionIndex = 0,
    super.score = 0,
    super.revealAnswer = false,
    super.selectedAnswer,
  });

  GameInProgress copyWith({
    int? questionIndex,
    int? score,
    bool? revealAnswer,
    Answer? selectedAnswer,
  }) =>
      GameInProgress(
        category: category,
        questions: questions,
        questionIndex: questionIndex ?? this.questionIndex,
        score: score ?? this.score,
        revealAnswer: revealAnswer ?? this.revealAnswer,
        selectedAnswer: selectedAnswer,
      );

  @override
  List<Object?> get props => [
    ...super.props,
    questionIndex,
    score,
    revealAnswer,
    selectedAnswer,
  ];
}

class GamePaused extends GameActive {
  const GamePaused({
    required super.category,
    required super.questions,
    required super.questionIndex,
    required super.score,
    required super.revealAnswer,
    required super.selectedAnswer,
  });
}

class GameEnded extends GameInitialized {
  const GameEnded({
    required super.category,
    required super.questions,
    required this.score,
  });

  final int score;

  @override
  List<Object?> get props => [...super.props, score];
}
