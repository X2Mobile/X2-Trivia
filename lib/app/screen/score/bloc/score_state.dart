import 'package:equatable/equatable.dart';

class ScoreState extends Equatable {
  const ScoreState();

  @override
  List<Object?> get props => [];
}

class SuccessScoreState extends ScoreState {
  const SuccessScoreState();
}

class ErrorScoreState extends ScoreState {
  const ErrorScoreState({
    required this.exception,
  }) : super();

  final String exception;

  @override
  List<Object?> get props => [exception];
}

class LoadingScoreState extends ScoreState {
  const LoadingScoreState();
}
