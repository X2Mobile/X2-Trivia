import 'package:equatable/equatable.dart';
import 'package:x2trivia/domain/models/answer.dart';
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

final class AnswerSelect extends GameEvent {
  const AnswerSelect({
    required this.answer,
  });

  final Answer answer;

  @override
  List<Object> get props => [answer];
}

final class AnswerUnselect extends GameEvent {
  const AnswerUnselect();

  @override
  List<Object> get props => [];
}

final class GameValidateAnswerEvent extends GameEvent {
  const GameValidateAnswerEvent();

  @override
  List<Object> get props => [];
}

final class GameSubmitAnswerEvent extends GameEvent {
  const GameSubmitAnswerEvent();

  @override
  List<Object> get props => [];
}
