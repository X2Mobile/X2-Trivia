import '../../domain/models/category.dart';

final class Constants {

  static final List<Category> categories = [
    Category(name: 'All categories'),
    Category(id: 0, name: 'General Knowledge'),
    Category(id: 21, name: 'Sports'),
    Category(id: 23, name: 'History'),
    Category(id: 31, name: 'Anime'),
  ];
}
