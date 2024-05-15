import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:x2trivia/app/screen/score/bloc/score_state.dart';
import 'package:x2trivia/app/util/build_context_helper.dart';
import 'package:x2trivia/domain/models/category.dart';
import 'package:x2trivia/domain/repositories/score_repository.dart';
import 'package:x2trivia/gen/assets.gen.dart';

import '../../../../domain/repositories/user_repository.dart';
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
    _scoreBloc.add(const ScoreSave());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScoreBloc, ScoreState>(
      listener: (context, state) {
        if (state is ScoreLoadError) {
          Fluttertoast.showToast(
            msg: state.exception,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            minimum: const EdgeInsets.only(left: 16, top: 128, right: 16, bottom: 16),
            child: scoreCard(context),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<ScoreBloc, ScoreState>(builder: (_, state) {
                return SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: state is ScoreInitial ? _onSaveScore : () {},
                    child: state is ScoreLoadInProgress
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator())
                        : state is ScoreLoadSuccess
                            ? saveScoreButtonContent()
                            : scoreSavedButtonContent(),
                  ),
                );
              }),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context)
                    ..pop()
                    ..pop(),
                  child: Text(context.strings.exit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget scoreCard(BuildContext context) => Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: Colors.transparent,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Assets.saveScore.image(),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        context.strings.finalScore,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      BlocBuilder<ScoreBloc, ScoreState>(
                        builder: (_, state) {
                          return Text(
                            state.score.toString(),
                            style: Theme.of(context).textTheme.titleLarge,
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(context.strings.category),
                      BlocBuilder<ScoreBloc, ScoreState>(
                        builder: (_, state) {
                          return Text(state.category.name);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );

  Widget saveScoreButtonContent() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check, size: 18),
          const SizedBox(width: 8),
          Text(context.strings.scoreSaved),
        ],
      );

  Widget scoreSavedButtonContent() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events_outlined, size: 18),
          const SizedBox(width: 8),
          Text(context.strings.save),
        ],
      );
}
