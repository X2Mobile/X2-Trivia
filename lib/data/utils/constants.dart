import '../../domain/models/category.dart';
import '../../gen/assets.gen.dart';

final class Constants {
  static const serverUrl = "https://opentdb.com/api.php?amount=10";

  static final List<Category> categories = [
    Category(id: -1, name: 'Random Questions', icon: Assets.icons.randomQuestions),
    Category(id: 0, name: 'General Knowledge', icon: Assets.icons.generalKnowledge),
    Category(id: 21, name: 'Sports', icon: Assets.icons.sports),
    Category(id: 23, name: 'History', icon: Assets.icons.history),
    Category(id: 31, name: 'Anime', icon: Assets.icons.anime),
  ];
}
