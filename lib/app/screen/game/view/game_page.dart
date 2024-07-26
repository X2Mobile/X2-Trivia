import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:x2trivia/app/blocs/game/game_bloc.dart';
import 'package:x2trivia/app/blocs/game/game_event.dart';
import 'package:x2trivia/app/blocs/game/game_state.dart';
import 'package:x2trivia/app/components/buttons/answer_button.dart';
import 'package:x2trivia/app/screen/score/view/score_page.dart';
import 'package:x2trivia/app/theme/colors.dart';
import 'package:x2trivia/app/util/build_context_helper.dart';
import 'package:x2trivia/domain/models/answer.dart';
import 'package:x2trivia/domain/models/category.dart';
import 'package:x2trivia/domain/models/question.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key, required this.category, this.state});

  static Route<void> route({required Category category}) => MaterialPageRoute(builder: (context) => GamePage(category: category));

  static Route<void> resume({required GamePaused state}) => MaterialPageRoute(builder: (context) => GamePage(category: state.category, state: state));

  final Category category;

  final GamePaused? state;

  @override
  Widget build(BuildContext context) {
    return GamePageView(category: category, state: state);
  }
}

class GamePageView extends StatefulWidget {
  const GamePageView({super.key, required this.category, required this.state});

  final Category category;

  final GamePaused? state;

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
    if (widget.state != null) {
      _onResumeGame(widget.state!);
    } else {
      _onStartNewGame();
    }
  }

  void _onEndGame() async {
    showDialog(
      context: context,
      builder: (context) => endGameConfirmation(context, _onPauseGame),
    );
  }

  void _onStartNewGame() => {gameBloc.add(GameQuestionsRequested(category: _category))};

  void _onResumeGame(GamePaused state) => gameBloc.add(GameResume(state: state));

  void _onAnswerSelected(Answer answer) => gameBloc.add(GameAnswerSelect(answer: answer));

  void _onAnswerUnselected() => gameBloc.add(const GameAnswerUnselect());

  void _onValidateAnswer() => gameBloc.add(const GameValidateAnswerEvent());

  void _onSubmitAnswer() => gameBloc.add(const GameSubmitAnswerEvent());

  void _onPauseGame() => gameBloc.add(const GamePause());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => _onEndGame(),
      child: BlocListener<GameBloc, GameState>(
        listener: (context, state) {
          if (state is GameInitialFetchingError) {
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
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              title: Text(_category.name),
              leading: CloseButton(onPressed: _onEndGame),
            ),
            body: content(context)),
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

            return SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          questionHeader(questions, questionIndex, score),
                          answerList(questions, questionIndex, answers, revealAnswer, selectedAnswer),
                        ],
                      ),
                    ),
                  ),
                  gameButton(questions, questionIndex, revealAnswer, selectedAnswer),
                ],
              ),
            );
          } else if (state is GameInitialFetching) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const SizedBox.shrink();
          }
        },
      );

  Widget questionHeader(List<Question> questions, int questionIndex, int score) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${questionIndex + 1} / ${questions.length}"),
                Text(context.strings.currentScore + score.toString()),
              ],
            ),
          ),
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
            padding: const EdgeInsets.only(top: 40.0, bottom: 8.0),
            child: Text(
              questions[questionIndex].question,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      );

  Widget answerList(List<Question> questions, int questionIndex, List<Answer> answers, bool revealAnswer, Answer? selectedAnswer) => Expanded(
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
      );

  Widget gameButton(List<Question> questions, int questionIndex, bool revealAnswer, Answer? selectedAnswer) =>
      Stack(alignment: AlignmentDirectional.bottomCenter, children: [
        AnimatedSlide(
          offset: Offset(0, !revealAnswer ? 0.3 : 0),
          duration: const Duration(milliseconds: 500),
          curve: Curves.linearToEaseOut,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.linearToEaseOut,
            child: !revealAnswer
                ? const SizedBox.shrink()
                : Container(
                    width: double.infinity,
                    color: selectedAnswer!.isCorrect ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15),
                    height: 120.0,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 14.0, left: 32.0),
                      child: Text(
                        selectedAnswer.isCorrect ? context.strings.correct : context.strings.wrong,
                        style: TextStyle(
                          color: selectedAnswer.isCorrect ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 32, left: 16, right: 16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: revealAnswer
                  ? FilledButton.styleFrom(backgroundColor: selectedAnswer!.isCorrect ? X2TriviaColors.greenCorrect : X2TriviaColors.redWrong)
                  : const ButtonStyle(),
              onPressed: revealAnswer
                  ? _onSubmitAnswer
                  : selectedAnswer != null
                      ? _onValidateAnswer
                      : null,
              child: revealAnswer
                  ? questionIndex + 1 == questions.length
                      ? Text(context.strings.finish)
                      : Text(context.strings.nextQuestion)
                  : Text(context.strings.checkAnswer),
            ),
          ),
        ),
      ]);
}

Widget endGameConfirmation(BuildContext context, VoidCallback onPauseGame) {
  return AlertDialog(
    title: Text(context.strings.endGameConfirmation),
    content: Text(context.strings.progressLoss),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.strings.cancel),
      ),
      TextButton(
        onPressed: () => Navigator.of(context)
          ..pop()
          ..pop(),
        child: Text(context.strings.quitGame),
      ),
      BlocBuilder<GameBloc, GameState>(
        builder: (_, state) {
          return !(state is GameInProgress && state.questionIndex == state.questions.length - 1 && state.revealAnswer)
              ? TextButton(
                  onPressed: () {
                    onPauseGame();
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                  },
                  child: Text(context.strings.pauseGame),
                )
              : const SizedBox.shrink();
        },
      ),
    ],
  );
}
