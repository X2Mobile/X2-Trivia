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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(context.strings.categories),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: BlocBuilder<CategoriesBloc, CategoriesState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: Constants.categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    final category = Constants.categories[index];

                    return CategoryButton(
                      category: category,
                      isSelected: state.selectedCategory?.id == category.id,
                      onPressed: () =>
                          state.selectedCategory == category ? _onCategoryUnselected() : _onCategorySelected(category),
                    );
                  },
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                            onPressed: state.selectedCategory != null
                                ? () => Navigator.of(context, rootNavigator: true)
                                    .push(GamePage.route(category: state.selectedCategory!))
                                : null,
                            child: Text(context.strings.startPlaying)),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
