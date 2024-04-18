import 'package:equatable/equatable.dart';

sealed class ScoreEvent extends Equatable {
  const ScoreEvent();

  @override
  List<Object> get props => [];
}

final class SaveScoreEvent extends ScoreEvent {
  const SaveScoreEvent();
}
