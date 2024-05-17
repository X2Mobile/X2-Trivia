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
        builder: (context) => const CategoriesPage(),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoriesBloc(),
      child: const CategoriesPageView(),
    );
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
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

}
