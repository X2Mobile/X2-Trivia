import 'package:flutter/material.dart';
import 'package:x2trivia/domain/models/answer.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    super.key,
    required this.answer,
    required this.isSelected,
    required this.isRevealed,
    required this.onPressed,
  });

  final Answer answer;
  final bool isSelected;
  final bool isRevealed;
  final VoidCallback? onPressed;

  bool get correctAnswer => isRevealed && answer.isCorrect;

  bool get wrongAnswerSelected => isRevealed && !answer.isCorrect && isSelected;

  Color containerColor(BuildContext context) => correctAnswer
      ? Colors.green.withOpacity(0.1)
      : wrongAnswerSelected
          ? Colors.red.withOpacity(0.1)
          : isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.12)
              : Colors.transparent;

  Border containerBorder(BuildContext context) => Border.all(
        strokeAlign: BorderSide.strokeAlignOutside,
        color: correctAnswer
            ? Colors.green
            : wrongAnswerSelected
                ? Colors.red
                : isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outlineVariant,
        width: isSelected || correctAnswer || wrongAnswerSelected ? 2.5 : 1.0,
      );

  TextStyle textStyle(BuildContext context) => correctAnswer
      ? const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)
      : wrongAnswerSelected
          ? const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
          : isSelected
              ? TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)
              : const TextStyle();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: containerColor(context),
          border: containerBorder(context),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            answer.text,
            style: textStyle(context),
          ),
        ),
      ),
    );
  }
}
