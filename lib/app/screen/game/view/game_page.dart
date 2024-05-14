import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:x2trivia/app/components/buttons/answer_button.dart';
import 'package:x2trivia/app/screen/game/bloc/game_bloc.dart';
import 'package:x2trivia/app/screen/game/bloc/game_event.dart';
import 'package:x2trivia/app/screen/game/bloc/game_state.dart';
import 'package:x2trivia/app/screen/score/view/score_page.dart';
import 'package:x2trivia/app/util/build_context_helper.dart';
import 'package:x2trivia/domain/models/answer.dart';
import 'package:x2trivia/domain/models/category.dart';
import 'package:x2trivia/domain/models/question.dart';
import 'package:x2trivia/domain/repositories/questions_repository.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key, required this.category});

  static Route<void> route({required Category category}) => MaterialPageRoute(
      builder: (context) => GamePage(
          category: category
      ));

  final Category category;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(
        questionsRepository: context.read<QuestionsRepository>(),
        category: category,
      ),
      child: GamePageView(category: category),
    );
  }
}

class GamePageView extends StatefulWidget {
  const GamePageView({super.key, required this.category});

  final Category category;

  @override
  State<GamePageView> createState() => _GamePageViewState();
}

class _GamePageViewState extends State<GamePageView> {
  late final GameBloc gameBloc;
  late final Category _category;

  @override
  void initState() {
    super.initState();
    gameBloc = context.read<GameBloc>();
    _category = widget.category;
  }

  void _onEndGame() async {
    showDialog(
      context: context,
      builder: (context) => endGameConfirmation(context),
    );
  }

  void _onAnswerSelected(Answer answer) => gameBloc.add(GameAnswerSelect(answer: answer));

  void _onAnswerUnselected() => gameBloc.add(const GameAnswerUnselect());

  void _onValidateAnswer() => gameBloc.add(const GameValidateAnswerEvent());

  void _onSubmitAnswer() => gameBloc.add(const GameSubmitAnswerEvent());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => _onEndGame(),
      child: BlocListener<GameBloc, GameState>(
        listener: (context, state) {
          if (state is GameLoadError) {
            Fluttertoast.showToast(
              msg: state.exception,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          } else if (state is GameEnded) {
            Navigator.of(context, rootNavigator: true).pushReplacement(ScorePage.route(score: state.score, category: state.category));
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(_category.name),
            leading: CloseButton(onPressed: _onEndGame),
          ),
          body: content(context)
        ),
      ),
    );
  }

  Widget content(BuildContext context) => BlocBuilder<GameBloc, GameState>(
    builder: (_, state) {
      if (state is GameInProgress) {
        int score = state.score;
        List<Question> questions = state.questions;
        int questionIndex = state.questionIndex;
        List<Answer> answers = questions[questionIndex].answers;
        bool revealAnswer = state.revealAnswer;
        Answer? selectedAnswer = state.selectedAnswer;

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
                  end: (questionIndex + 1) / questions.length,
                ),
                builder: (context, value, _) => LinearProgressIndicator(value: value),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(context.strings.currentScore + score.toString()),
              ),
              Text(
                questions[questionIndex].question,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: questions[questionIndex].answers.length,
                  itemBuilder: (BuildContext context, int index) {
                    Answer answer = answers[index];
                    return SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: AnswerButton(
                          answer: answer,
                          isSelected: answer == selectedAnswer,
                          isRevealed: revealAnswer,
                          onPressed: revealAnswer ? null : () => selectedAnswer == answer ? _onAnswerUnselected() : _onAnswerSelected(answer),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: revealAnswer
                        ? _onSubmitAnswer
                        : selectedAnswer != null
                          ? _onValidateAnswer
                          : null,
                    child: revealAnswer
                        ? questionIndex + 1 == questions.length
                          ? Text(context.strings.finish)
                          : Text(context.strings.next)
                        : Text(context.strings.submit),
                  ),
                ),
              )
            ],
          ),
        );
      } else if (state is GameLoadInProgress) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return const SizedBox.shrink();
      }
    },
  );

  Widget endGameConfirmation(BuildContext context) {
    return AlertDialog(
      title: Text(context.strings.endGameConfirmation),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.strings.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context)
            ..pop()
            ..pop(),
          child: Text(context.strings.endGame),
        ),
      ],
    );
  }
}
