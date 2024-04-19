final class Score {
  final String email;
  final String name;
  final int categoryId;
  final int score;
  final DateTime date;

  Score({
    required this.email,
    required this.name,
    required this.categoryId,
    required this.score,
    required this.date,
  });

  toJson() {
    return {
      'email': email,
      'name': name,
      'categoryId': categoryId,
      'score': score,
      'date': date,
    };
  }
}
