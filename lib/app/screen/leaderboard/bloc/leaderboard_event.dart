import 'package:equatable/equatable.dart';

sealed class LeaderboardEvent extends Equatable {
  const LeaderboardEvent();

  @override
  List<Object> get props => [];
}

final class LeaderboardRequested extends LeaderboardEvent {
  const LeaderboardRequested();

  @override
  List<Object> get props => [];
}
