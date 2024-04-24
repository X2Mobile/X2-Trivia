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
}
