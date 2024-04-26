import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:x2trivia/app/screen/leaderboard/bloc/leaderboard_bloc.dart';
import 'package:x2trivia/app/screen/leaderboard/bloc/leaderboard_event.dart';
import 'package:x2trivia/app/screen/leaderboard/bloc/leaderboard_state.dart';
import 'package:x2trivia/app/util/build_context_helper.dart';
import 'package:x2trivia/data/utils/constants.dart';
import 'package:x2trivia/domain/models/category.dart';
import 'package:x2trivia/domain/models/leaderboard_entry.dart';
import 'package:x2trivia/domain/repositories/score_repository.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  static Route<Category> route() => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => LeaderboardBloc(
            scoreRepository: context.read<ScoreRepository>(),
          ),
          child: const LeaderboardPageView(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return const LeaderboardPageView();
  }
}

class LeaderboardPageView extends StatefulWidget {
  const LeaderboardPageView({super.key});

  @override
  State<LeaderboardPageView> createState() => _LeaderboardPageViewState();
}

class _LeaderboardPageViewState extends State<LeaderboardPageView> {
  late final LeaderboardBloc leaderboardBloc;

  @override
  void initState() {
    super.initState();
    leaderboardBloc = context.read<LeaderboardBloc>();
  }

  void _onSort(bool sortAscending) => leaderboardBloc.add(LeaderboardSort(sortAscending: sortAscending));

  void _onCategorySelected(Category category) => leaderboardBloc.add(LeaderboardCategorySelect(category: category));

  @override
  Widget build(BuildContext context) {
    final columnWidth = MediaQuery.of(context).size.width / 4;

    return BlocListener<LeaderboardBloc, LeaderboardState>(
      listener: (context, state) {
        if (state is LeaderboardLoadError) {
          Fluttertoast.showToast(
            msg: state.exception,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(context.strings.leaderboard),
        ),
        body: BlocBuilder<LeaderboardBloc, LeaderboardState>(
          builder: (_, state) {
            if (state is LeaderboardLoadSuccess) {
              List<LeaderboardEntry> entries = state.entries.where((element) => element.categoryId == state.selectedCategory?.id).toList();
              if (state.sortAscending) {
                entries.sort((a, b) => a.averageScore.compareTo(b.averageScore));
              } else {
                entries.sort((a, b) => b.averageScore.compareTo(a.averageScore));
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    DropdownButton(
                      value: state.selectedCategory,
                      items: Constants.categories.map<DropdownMenuItem<Category>>(
                        (Category category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(category.name),
                          );
                        },
                      ).toList(),
                      onChanged: (Category? newValue) {
                        _onCategorySelected(newValue!);
                      },
                    ),
                    buildLeaderboardDataTable(context, entries, state.sortAscending, _onSort, columnWidth)
                  ],
                ),
              );
            } else if (state is LeaderboardLoadInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget buildLeaderboardDataTable(BuildContext context, List<LeaderboardEntry> entries, bool sortAscending, Function(bool) onSort, double columnWidth) {
    return FittedBox(
      child: DataTable(
        columnSpacing: 10,
        sortColumnIndex: 3,
        sortAscending: sortAscending,
        showBottomBorder: true,
        columns: [
          DataColumn(label: SizedBox(width: columnWidth, child: Center(child: Text(context.strings.rank)))),
          DataColumn(label: SizedBox(width: columnWidth, child: Center(child: Text(context.strings.name)))),
          DataColumn(label: SizedBox(width: columnWidth, child: Center(child: Text(context.strings.categoryTitle)))),
          DataColumn(
              label: SizedBox(width: columnWidth, child: Center(child: Text(context.strings.averageScore))),
              onSort: (_, ascending) {
                onSort(ascending);
              },
          ),
        ],
        rows: List.generate(
          entries.length,
          (index) {
            final entry = entries[index];
            return DataRow(
              cells: [
                DataCell(Center(child: Text('${index + 1}'))),
                DataCell(Center(child: Text(entry.name))),
                DataCell(Center(child: Text(Constants.categories.firstWhere((category) => category.id == entry.categoryId).name))),
                DataCell(Center(child: Text(entry.averageScore.toStringAsFixed(2)))),
              ],
            );
          },
        ),
      ),
    );
  }
}
