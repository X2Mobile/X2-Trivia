import 'package:x2trivia/domain/models/answer.dart';
import 'package:x2trivia/domain/models/category.dart';
import 'package:x2trivia/domain/models/question.dart';
import 'package:x2trivia/gen/assets.gen.dart';

class DemoData {
  static Category kTestCategory = Category(id: -1, name: 'Random Questions', icon: Assets.icons.randomQuestions);

  static List<Question> kTestQuestions = [
    Question(
      type: 'multiple',
      difficulty: 'easy',
      category: 'Anime',
      question: 'Demo question 1',
      answers: [
        Answer('Demo answer 11', true),
        Answer('Demo answer 12', false),
        Answer('Demo answer 13', false),
      ],
    ),
    Question(
      type: 'boolean',
      difficulty: 'hard',
      category: 'History',
      question: 'Demo question 2',
      answers: [
        Answer('False', true),
        Answer('True', false),
      ],
    ),
    Question(
      type: 'multiple',
      difficulty: 'medium',
      category: 'General Knowledge',
      question: 'Demo question 3',
      answers: [
        Answer('Demo answer 31', false),
        Answer('Demo answer 32', true),
        Answer('Demo answer 33', false),
      ],
    ),
    Question(
      type: 'multiple',
      difficulty: 'hard',
      category: 'Anime',
      question: 'Demo question 4',
      answers: [
        Answer('Demo answer 41', false),
        Answer('Demo answer 42', false),
        Answer('Demo answer 43', true),
      ],
    ),
    Question(
      type: 'multiple',
      difficulty: 'easy',
      category: 'History',
      question: 'Demo question 5',
      answers: [
        Answer('Demo answer 51', false),
        Answer('Demo answer 52', true),
        Answer('Demo answer 53', false),
      ],
    ),
    Question(
      type: 'boolean',
      difficulty: 'medium',
      category: 'General Knowledge',
      question: 'Demo question 6',
      answers: [
        Answer('False', false),
        Answer('True', true),
      ],
    ),
    Question(
      type: 'multiple',
      difficulty: 'hard',
      category: 'Anime',
      question: 'Demo question 7',
      answers: [
        Answer('Demo answer 71', true),
        Answer('Demo answer 72', false),
        Answer('Demo answer 73', false),
      ],
    ),
    Question(
      type: 'multiple',
      difficulty: 'medium',
      category: 'History',
      question: 'Demo question 8',
      answers: [
        Answer('Demo answer 81', false),
        Answer('Demo answer 82', false),
        Answer('Demo answer 83', true),
      ],
    ),
    Question(
      type: 'boolean',
      difficulty: 'hard',
      category: 'General Knowledge',
      question: 'Demo question 9',
      answers: [
        Answer('False', false),
        Answer('True', true),
      ],
    ),
    Question(
      type: 'multiple',
      difficulty: 'medium',
      category: 'Anime',
      question: 'Demo question 10',
      answers: [
        Answer('Demo answer 101', false),
        Answer('Demo answer 102', false),
        Answer('Demo answer 103', true),
      ],
    ),
  ];
}
