import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:x2trivia/app/screen/game/bloc/game_bloc.dart';
import 'package:x2trivia/app/screen/game/bloc/game_event.dart';
import 'package:x2trivia/app/screen/game/bloc/game_state.dart';
import 'package:x2trivia/app/screen/score/view/score_page.dart';
import 'package:x2trivia/app/util/build_context_helper.dart';
import 'package:x2trivia/domain/models/category.dart';
import 'package:x2trivia/domain/models/question.dart';
import 'package:x2trivia/domain/repositories/questions_repository.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  static Route<void> route({required Category category}) => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => GameBloc(
            questionsRepository: context.read<QuestionsRepository>(),
            category: category,
          ),
          child: const GamePageView(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return const GamePageView();
  }
}

class GamePageView extends StatefulWidget {
  const GamePageView({super.key});

  @override
  State<GamePageView> createState() => _GamePageViewState();
}

class _GamePageViewState extends State<GamePageView> {
  late final GameBloc gameBloc;

  @override
  void initState() {
    super.initState();
    gameBloc = context.read<GameBloc>();
  }

  void _onValidateAnswer(bool correctAnswer) => gameBloc.add(GameValidateAnswerEvent(correctAnswer: correctAnswer));

  void _onSubmitAnswer() => gameBloc.add(const GameSubmitAnswerEvent());

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBloc, GameState>(
      listener: (context, state) {
        if (state is GameLoadError) {
          Fluttertoast.showToast(
            msg: state.exception,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        } else if (state is GameEnded) {
          Navigator.of(context, rootNavigator: true).pushReplacement(ScorePage.route(score: state.score, category: state.category!));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(context.strings.game),
        ),
        body: BlocBuilder<GameBloc, GameState>(
          builder: (_, state) {
            if (state is GameLoadSuccess) {
              int score = state.score;
              List<Question> questions = state.questions;
              int questionIndex = state.questionIndex;
              Map<String, bool> answers = questions[questionIndex].answers;
              bool revealAnswer = state.revealAnswer;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text("${questionIndex + 1} / ${questions.length}"),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(
                        begin: 0,
                        end: (questionIndex + (revealAnswer ? 1 : 0)) / questions.length,
                      ),
                      builder: (context, value, _) => LinearProgressIndicator(value: value),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(context.strings.currentScore + score.toString()),
                    ),
                    Text(questions[questionIndex].question,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: questions[questionIndex].answers.length,
                        itemBuilder: (BuildContext context, int index) {
                          String answerText = answers.keys.toList()[index];
                          bool isCorrect = answers.values.toList()[index];
                          return SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () => revealAnswer ? null : _onValidateAnswer(isCorrect),
                              style: revealAnswer
                                  ? ButtonStyle(
                                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                        if (isCorrect) {
                                          return Colors.green;
                                        } else {
                                          return Colors.red;
                                        }
                                      }),
                                      foregroundColor: MaterialStateProperty.all(Colors.white))
                                  : const ButtonStyle(),
                              child: Text(answerText),
                            ),
                          );
                        },
                      ),
                    ),
                    if (revealAnswer)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () => _onSubmitAnswer(),
                            child: questionIndex + 1 == questions.length ? Text(context.strings.finish) : Text(context.strings.next),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            } else if (state is GameLoadInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
