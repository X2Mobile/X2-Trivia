import 'package:equatable/equatable.dart';

class ScoreState extends Equatable {
  const ScoreState();

  @override
  List<Object?> get props => [];
}

class ScoreLoadSuccess extends ScoreState {
  const ScoreLoadSuccess();
}

class ScoreLoadError extends ScoreState {
  const ScoreLoadError({
    required this.exception,
  }) : super();

  final String exception;

  @override
  List<Object?> get props => [exception];
}

class ScoreLoadInProgress extends ScoreState {
  const ScoreLoadInProgress();
}
