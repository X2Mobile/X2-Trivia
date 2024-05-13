import '../../domain/models/category.dart';

final class Constants {
  static const serverUrl = "https://opentdb.com/api.php?amount=10";

  static final List<Category> categories = [
    Category(id: -1, name: 'All categories'),
    Category(id: 0, name: 'General Knowledge'),
    Category(id: 21, name: 'Sports'),
    Category(id: 23, name: 'History'),
    Category(id: 31, name: 'Anime'),
  ];
}
