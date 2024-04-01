import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:x2trivia/app/screen/categories/bloc/categories_bloc.dart';
import 'package:x2trivia/app/screen/categories/bloc/categories_event.dart';
import 'package:x2trivia/app/screen/categories/bloc/categories_state.dart';
import 'package:x2trivia/app/util/build_context_helper.dart';

import '../../../../data/utils/constants.dart';
import '../../../../domain/models/category.dart';
import '../../../components/buttons/category_button.dart';
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
  late final CategoriesBloc selectCategoryBloc;

  @override
  void initState() {
    super.initState();
    selectCategoryBloc = context.read<CategoriesBloc>();
  }

  void _onCategorySelected(Category category) => selectCategoryBloc.add(CategorySelect(category: category));

  void _onCategoryUnselected() => selectCategoryBloc.add(const CategoryUnselect());

  @override
  Widget build(BuildContext context) {
    CategoriesState state = context.watch<CategoriesBloc>().state;
    Category? selectedCategory = state.selectedCategory;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(context.strings.selectCategory),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Constants.categories.length,
                itemBuilder: (BuildContext context, int index) {
                  final category = Constants.categories[index];

                  return CategoryButton(
                    category: category,
                    isSelected: selectedCategory != null && selectedCategory.id == category.id,
                    onPressed: () => selectedCategory == category
                        ? _onCategoryUnselected()
                        : _onCategorySelected(category),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                  onPressed: selectedCategory != null
                      ? () => Navigator.of(context, rootNavigator: true).push(GamePage.route(category: selectedCategory))
                      : null,
                  child: Text(context.strings.startGame)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
