import 'dart:convert';
import 'package:x2trivia/data/utils/constants.dart';
import 'package:x2trivia/domain/models/category.dart';
import 'package:x2trivia/domain/models/question.dart';
import 'package:x2trivia/domain/repositories/questions_repository.dart';
import 'package:http/http.dart' as http;

class DataQuestionsRepository extends QuestionsRepository {
  @override
  Future<List<Question>> getQuestions(Category category) async {
    final url = category.id == -1
        ? Uri.parse(Constants.serverUrl)
        : Uri.parse('${Constants.serverUrl}&category=${category.id}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        if (decodedData['response_code'] == 0) {
          final List<Map<String, dynamic>> questionsData = List<Map<String, dynamic>>.from(decodedData['results']);

          final List<Question> questions = questionsData.map((questionData) {
            return Question.fromJson(questionData);
          }).toList();

          return questions;
        } else {
          throw Exception('API error: ${decodedData['response_code']}');
        }
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
