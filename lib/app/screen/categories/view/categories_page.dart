import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x2trivia/app/blocs/game/game_event.dart';
import 'package:x2trivia/app/screen/categories/bloc/categories_bloc.dart';
import 'package:x2trivia/app/screen/categories/bloc/categories_event.dart';
import 'package:x2trivia/app/screen/categories/bloc/categories_state.dart';
import 'package:x2trivia/app/blocs/game/game_state.dart';
import 'package:x2trivia/app/util/build_context_helper.dart';

import '../../../../data/utils/constants.dart';
import '../../../../domain/models/category.dart';
import '../../../components/buttons/category_button.dart';
import '../../../blocs/game/game_bloc.dart';
import '../../game/view/game_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  static Route<Category> route() => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => CategoriesBloc(),
          child: const CategoriesPageView(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return const CategoriesPageView();
  }
}

class CategoriesPageView extends StatefulWidget {
  const CategoriesPageView({super.key});

  @override
  State<CategoriesPageView> createState() => _CategoriesPageViewState();
}

class _CategoriesPageViewState extends State<CategoriesPageView> {
  late final CategoriesBloc categoriesBloc;
  late final GameBloc gameBloc;

  @override
  void initState() {
    super.initState();
    categoriesBloc = context.read<CategoriesBloc>();
    gameBloc = context.read<GameBloc>();
  }

  void _onCategorySelected(Category category) => categoriesBloc.add(CategorySelect(category: category));

  void _onCategoryUnselected() => categoriesBloc.add(const CategoryUnselect());

  void _onStartNewGame(Category category) => gameBloc.add(GameQuestionsRequested(category: category));

  void _onResumeGame() => gameBloc.add(GameResume());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        title: Text(context.strings.categories),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(vertical: 16),
        child: BlocBuilder<CategoriesBloc, CategoriesState>(
          builder: (context, state) {
            return BlocBuilder<GameBloc, GameState>(
              builder: (context, gameState) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    categoriesList(state.selectedCategory),
                    resumeGameButton(gameState),
                    startGameButton(state.selectedCategory),
                  ],
                );
              }
            );
          },
        ),
      ),
    );
  }

  Widget categoriesList(Category? selectedCategory) => Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: Constants.categories.length,
          itemBuilder: (BuildContext context, int index) {
            final category = Constants.categories[index];

            return CategoryButton(
              category: category,
              isSelected: selectedCategory?.id == category.id,
              onPressed: () => selectedCategory == category ? _onCategoryUnselected() : _onCategorySelected(category),
            );
          },
        ),
      );

  Widget startGameButton(Category? selectedCategory) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
              onPressed: selectedCategory != null ? () {
                Navigator.of(context, rootNavigator: true).push(GamePage.route(category: selectedCategory));
                _onStartNewGame(selectedCategory);
              } : null,
              child: Text(context.strings.startPlaying)),
        ),
      );

  Widget resumeGameButton(GameState state) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: SizedBox(
      width: double.infinity,
      child: FilledButton(
          onPressed: state is GamePaused ?  () {
            Navigator.of(context, rootNavigator: true).push(GamePage.route(category: state.category));
            _onResumeGame();
          } : null,
          child: Text(context.strings.resumeGame),
      ),
    ),
  );
}
