import 'package:equatable/equatable.dart';
import 'package:x2trivia/domain/models/category.dart';

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

final class GameQuestionsRequestedEvent extends GameEvent {
  const GameQuestionsRequestedEvent({
    required this.category,
  });

  final Category category;

  @override
  List<Object> get props => [category];
}

final class GameValidateAnswerEvent extends GameEvent {
  const GameValidateAnswerEvent({
    required this.correctAnswer,
  });

  final bool correctAnswer;

  @override
  List<Object> get props => [correctAnswer];
}

final class GameSubmitAnswerEvent extends GameEvent {
  const GameSubmitAnswerEvent();

  @override
  List<Object> get props => [];
}
