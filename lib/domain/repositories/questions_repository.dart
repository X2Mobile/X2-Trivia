import 'package:x2trivia/domain/models/category.dart';
import 'package:x2trivia/domain/models/question.dart';

abstract class QuestionsRepository {
  Future<List<Question>> getQuestions(Category category);
}
