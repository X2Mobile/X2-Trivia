import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:x2trivia/domain/repositories/score_repository.dart';

import '../domain/models/score.dart';

class DataScoreRepository extends ScoreRepository {
  @override
  Future<void> addScore(Score score) async {
    try {
      await FirebaseFirestore.instance.collection("scores").add(score.toJson());
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  Future<List<Score>> getScores(DateTime from, DateTime to) async {
    try {
      var scores = await FirebaseFirestore.instance
          .collection("scores")
          .where("date", isGreaterThanOrEqualTo: from)
          .where("date", isLessThanOrEqualTo: to)
          .get();
      return scores.docs.map((document) => Score.fromJson(document.data())).toList();
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
