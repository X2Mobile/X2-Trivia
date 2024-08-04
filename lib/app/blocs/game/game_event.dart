import 'package:equatable/equatable.dart';
import 'package:x2trivia/domain/models/answer.dart';
import 'package:x2trivia/domain/models/category.dart';

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

final class GameQuestionsRequested extends GameEvent {
  const GameQuestionsRequested({
    required this.category,
  });

  final Category category;

  @override
  List<Object> get props => [category];
}

final class GameAnswerSelect extends GameEvent {
  const GameAnswerSelect({
    required this.answer,
  });

  final Answer answer;

  @override
  List<Object> get props => [answer];
}

final class GameAnswerUnselect extends GameEvent {
  const GameAnswerUnselect();

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

final class GamePause extends GameEvent {
  const GamePause();

  @override
  List<Object> get props => [];
}

final class GameResume extends GameEvent {

  @override
  List<Object> get props => [];
}