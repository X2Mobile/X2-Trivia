import 'package:equatable/equatable.dart';
import 'package:x2trivia/domain/models/answer.dart';
import 'package:x2trivia/domain/models/category.dart';
import 'package:x2trivia/domain/models/question.dart';

sealed class GameState extends Equatable {
  final Category category;

  @override
  List<Object?> get props => [category];

  const GameState({required this.category});
}

class GameInProgress extends GameState {
  const GameInProgress({
    required super.category,
    required this.questions,
    this.questionIndex = 0,
    this.score = 0,
    this.revealAnswer = false,
    this.selectedAnswer
  });

  final List<Question> questions;
  final int questionIndex;
  final int score;
  final bool revealAnswer;
  final Answer? selectedAnswer;

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
  List<Object?> get props => [questions, questionIndex, score, revealAnswer, selectedAnswer];
}

class GameLoadError extends GameState {
  const GameLoadError({
    required super.category,
    required this.exception,
  });

  final String exception;

  @override
  List<Object?> get props => [exception];
}

class GameLoadInProgress extends GameState {
  const GameLoadInProgress({required super.category});
}

class GameEnded extends GameState {
  const GameEnded({
    required super.category,
    required this.score,
  });

  final int score;
}
