import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:x2trivia/app/screen/score/bloc/score_state.dart';
import 'package:x2trivia/app/util/build_context_helper.dart';
import 'package:x2trivia/data/exceptions/login_exceptions.dart';

import '../../../../domain/models/category.dart' as category_import;
import '../../../../domain/repositories/user_repository.dart';
import '../../leaderboard/view/leaderboard_page.dart';
import '../bloc/score_bloc.dart';
import '../bloc/score_event.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({Key? key, required this.score, required this.category}) : super(key: key);

  static Route<void> route({required int score, required category_import.Category category}) => MaterialPageRoute(
      builder: (context) => ScorePage(
            score: score,
            category: category,
          ));

  final int score;
  final category_import.Category category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ScoreBloc(
        userRepository: context.read<UserRepository>(),
        category: category,
        score: score,
      ),
      child: const ScorePageView(),
    );
  }
}

class ScorePageView extends StatefulWidget {
  const ScorePageView({Key? key}) : super(key: key);

  @override
  State<ScorePageView> createState() => _ScorePageViewState();
}

class _ScorePageViewState extends State<ScorePageView> {
  late final ScoreBloc scoreBloc;

  @override
  void initState() {
    super.initState();
    scoreBloc = context.read<ScoreBloc>();
  }

  void _onSaveScore() {
    scoreBloc.add(const SaveScoreEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScoreBloc, ScoreState>(
        listener: (context, state) {
          if (state is SuccessScoreState) {
            Navigator.of(context, rootNavigator: true).pushReplacement(LeaderboardPage.route());
          }
          if (state is ErrorScoreState) {
            Fluttertoast.showToast(
              msg: state.exception.getMessage(context),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 100.0, left: 16.0, right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.strings.score,
                      style: const TextStyle(
                        fontSize: 50,
                      ),
                    ),
                    Text(
                      scoreBloc.score.toString(),
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.strings.category,
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      scoreBloc.category.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                        onPressed: () => _onSaveScore(),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(context.strings.save, style: const TextStyle(fontSize: 20)),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<ScoreBloc, ScoreState>(
                    builder: (_, state) {
                      if (state is LoadingScoreState) {
                        return const CircularProgressIndicator(
                          value: null,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
