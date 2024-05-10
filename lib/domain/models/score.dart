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

  Score.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        name = json['name'],
        categoryId = json['categoryId'],
        score =json['score'],
        date = json['date'].toDate();

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
