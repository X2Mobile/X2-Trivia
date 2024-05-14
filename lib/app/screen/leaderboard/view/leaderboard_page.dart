import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:x2trivia/app/screen/leaderboard/bloc/leaderboard_bloc.dart';
import 'package:x2trivia/app/screen/leaderboard/bloc/leaderboard_state.dart';
import 'package:x2trivia/app/theme/colors.dart';
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

  @override
  Widget build(BuildContext context) {
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
      child: DefaultTabController(
        length: Constants.categories.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            title: Text(context.strings.leaderboard),
            bottom: TabBar(
              tabs: Constants.categories.map((category) => Tab(text: category.name.split(" ").first)).toList(),
              tabAlignment: TabAlignment.center,
            ),
          ),
          body: BlocBuilder<LeaderboardBloc, LeaderboardState>(
            builder: (_, state) {
              if (state is LeaderboardLoadSuccess) {
                List<LeaderboardEntry> entries = state.entries.toList();
                entries.sort((a, b) => b.averageScore.compareTo(a.averageScore));

                return TabBarView(
                    children: Constants.categories
                        .map((category) => buildLeaderboard(context, entries.where((element) => element.categoryId == category.id).toList()))
                        .toList());
              } else if (state is LeaderboardLoadInProgress) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildLeaderboard(BuildContext context, List<LeaderboardEntry> entries) {
    Color getCircleAvatarColor(int rank) {
      switch (rank) {
        case 1:
          return X2TriviaColors.leaderboard1st;
        case 2:
          return X2TriviaColors.leaderboard2nd;
        case 3:
          return X2TriviaColors.leaderboard3rd;
        default:
          return X2TriviaColors.leaderboardOthers;
      }
    }

    return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: getCircleAvatarColor(index + 1),
                  child: Text((index + 1).toString()),
                ),
                trailing: Text(
                  entries[index].averageScore.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                title: Text(entries[index].name),
              ),
              const Divider(indent: 16),
            ],
          );
        });
  }
}
