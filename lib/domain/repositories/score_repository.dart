import 'package:x2trivia/domain/models/score.dart';

abstract class ScoreRepository {
  Future<void> addScore(Score score);
  Future<List<Score>> getScores(DateTime from, DateTime to);
}
