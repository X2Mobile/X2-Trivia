import 'package:equatable/equatable.dart';
import 'package:x2trivia/domain/models/category.dart';
import 'package:x2trivia/domain/models/leaderboard_entry.dart';

sealed class LeaderboardState extends Equatable {
  @override
  List<Object?> get props => [];

  const LeaderboardState();
}

class LeaderboardLoadSuccess extends LeaderboardState {
  const LeaderboardLoadSuccess({
    required this.entries,
    this.selectedCategory,
    this.sortAscending = false,
  });

  final bool sortAscending;
  final List<LeaderboardEntry> entries;
  final Category? selectedCategory;

  LeaderboardLoadSuccess copyWith({
    bool? sortAscending,
    List<LeaderboardEntry>? entries,
    Category? category,
  }) => LeaderboardLoadSuccess(entries: entries ?? this.entries, selectedCategory: category ?? selectedCategory, sortAscending: sortAscending ?? this.sortAscending);

  @override
  List<Object?> get props => [entries, selectedCategory, sortAscending];
}

class LeaderboardLoadError extends LeaderboardState {
  const LeaderboardLoadError({
    required this.exception,
  });

  final String exception;

  @override
  List<Object?> get props => [exception];
}

class LeaderboardLoadInProgress extends LeaderboardState {
  const LeaderboardLoadInProgress();
}
