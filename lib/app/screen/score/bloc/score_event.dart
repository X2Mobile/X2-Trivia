import 'package:equatable/equatable.dart';

sealed class ScoreEvent extends Equatable {
  const ScoreEvent();

  @override
  List<Object> get props => [];
}

final class ScoreSave extends ScoreEvent {
  const ScoreSave();
}
