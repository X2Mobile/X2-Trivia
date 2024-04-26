import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:x2trivia/app/screen/score/bloc/score_state.dart';
import 'package:x2trivia/app/util/build_context_helper.dart';
import 'package:x2trivia/domain/models/category.dart';
import 'package:x2trivia/domain/repositories/score_repository.dart';

import '../../../../domain/repositories/user_repository.dart';
import '../../leaderboard/view/leaderboard_page.dart';
import '../bloc/score_bloc.dart';
import '../bloc/score_event.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({Key? key, required this.score, required this.category}) : super(key: key);

  static Route<void> route({required int score, required Category category}) => MaterialPageRoute(
      builder: (context) => ScorePage(
            score: score,
            category: category,
          ));

  final int score;
  final Category category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ScoreBloc(
        userRepository: context.read<UserRepository>(),
        scoreRepository: context.read<ScoreRepository>(),
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
  late final ScoreBloc _scoreBloc;

  @override
  void initState() {
    super.initState();
    _scoreBloc = context.read<ScoreBloc>();
  }

  void _onSaveScore() {
    _scoreBloc.add(const SaveScoreEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScoreBloc, ScoreState>(
        listener: (context, state) {
          if (state is ScoreLoadSuccess) {
            Navigator.of(context, rootNavigator: true).pushReplacement(LeaderboardPage.route());
          }
          if (state is ScoreLoadError) {
            Fluttertoast.showToast(
              msg: state.exception,
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
                    BlocBuilder<ScoreBloc, ScoreState>(
                      builder: (_, state) {
                        return Text(
                          state.score.toString(),
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      },
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
                    BlocBuilder<ScoreBloc, ScoreState>(
                      builder: (_, state) {
                        return Text(
                          state.category.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      },
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
                      if (state is ScoreLoadInProgress) {
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
