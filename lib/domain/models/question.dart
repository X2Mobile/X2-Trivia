import 'package:x2trivia/app/util/utils.dart';
import 'package:x2trivia/domain/models/answer.dart';

final class Question {
  final String type;
  final String difficulty;
  final String category;
  final String question;
  late final List<Answer> answers;

  Question({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.question,
    required this.answers,
  });

  Question.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        difficulty = json['difficulty'],
        category = json['category'],
        question = Utils.decodeHtml(json['question']) {
    List<String> tempAnswers = List<String>.from(json['incorrect_answers']).map((answer) => Utils.decodeHtml(answer)).toList();
    String correctAnswer = Utils.decodeHtml(json['correct_answer']);
    tempAnswers.add(correctAnswer);
    tempAnswers.shuffle();

    answers = tempAnswers.map((answer) => Answer(answer, answer == correctAnswer)).toList();
  }
}
