import 'package:equatable/equatable.dart';
import 'package:x2trivia/domain/models/category.dart';

sealed class ScoreState extends Equatable {
  const ScoreState(this.score, this.category);

  final int score;
  final Category category;

  @override
  List<Object?> get props => [score, category];
}

class ScoreInitial extends ScoreState {
  const ScoreInitial(
    int score,
    Category category,
  ) : super(score, category);

  ScoreInitial.fromState(ScoreState state) : super(state.score, state.category);

  @override
  List<Object?> get props => [score, category];
}

class ScoreLoadSuccess extends ScoreState {
  const ScoreLoadSuccess(
    int score,
    Category category,
  ) : super(score, category);

  ScoreLoadSuccess.fromState(ScoreState state) : super(state.score, state.category);

  @override
  List<Object?> get props => [score, category];
}

class ScoreLoadError extends ScoreState {
  const ScoreLoadError(
    this.exception,
    int score,
    Category category,
  ) : super(score, category);

  ScoreLoadError.fromState(ScoreState state, this.exception) : super(state.score, state.category);

  final String exception;

  @override
  List<Object?> get props => [exception, score, category];
}

class ScoreLoadInProgress extends ScoreState {
  const ScoreLoadInProgress(
    int score,
    Category category,
  ) : super(score, category);

  ScoreLoadInProgress.fromState(ScoreState state) : super(state.score, state.category);

  @override
  List<Object?> get props => [score, category];
}
