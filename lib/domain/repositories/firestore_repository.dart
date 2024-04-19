import 'package:x2trivia/domain/models/score.dart';

abstract class FirestoreRepository {
  Future<void> addScore(Score score);
}
