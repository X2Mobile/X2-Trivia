import 'package:equatable/equatable.dart';
import 'package:x2trivia/domain/models/category.dart';

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

final class LeaderboardSort extends LeaderboardEvent {
  const LeaderboardSort({
    required this.sortAscending,
  });

  final bool sortAscending;

  @override
  List<Object> get props => [sortAscending];
}

final class LeaderboardCategorySelect extends LeaderboardEvent {
  const LeaderboardCategorySelect({
    required this.category,
  });

  final Category? category;

  @override
  List<Object> get props => [];
}
