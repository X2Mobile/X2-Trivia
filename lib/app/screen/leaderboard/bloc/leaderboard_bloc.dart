import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:x2trivia/app/screen/leaderboard/bloc/leaderboard_event.dart';
import 'package:x2trivia/app/screen/leaderboard/bloc/leaderboard_state.dart';
import 'package:x2trivia/data/utils/constants.dart';
import 'package:x2trivia/domain/models/leaderboard_entry.dart';
import 'package:x2trivia/domain/models/score.dart';
import 'package:x2trivia/domain/repositories/score_repository.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  LeaderboardBloc({
    required this.scoreRepository,
  }) : super(const LeaderboardLoadInProgress()) {
    on<LeaderboardRequested>(_onLeaderboardRequested);
    add(const LeaderboardRequested());
  }

  final ScoreRepository scoreRepository;

  Future<void> _onLeaderboardRequested(
    LeaderboardRequested event,
    Emitter<LeaderboardState> emit,
  ) async {
    try {
      final List<Score> scores = await scoreRepository.getScores(DateTime.now().subtract(Duration(days: DateTime.now().weekday + 6)), DateTime.now());

      emit(LeaderboardLoadSuccess(entries: extractLeaderboardEntries(scores), selectedCategory: Constants.categories.first));
    } catch (error) {
      emit(LeaderboardLoadError(exception: error.toString()));
    }
  }

  List<LeaderboardEntry> extractLeaderboardEntries(List<Score> scores) {
    return groupBy(scores, (entry) => entry.email)
        .map((email, entriesByEmail) => MapEntry(
            email,
            groupBy(entriesByEmail, (entry) => entry.categoryId).map(
              (categoryId, entriesByCategory) => MapEntry(
                categoryId,
                LeaderboardEntry(
                  averageScore: entriesByCategory.map((entry) => entry.score).reduce((a, b) => a + b) / entriesByCategory.length,
                  categoryId: categoryId,
                  name: entriesByCategory.first.name,
                )
              )
            )
          )
        ).values.expand((map) => map.values).toList();
  }
}
