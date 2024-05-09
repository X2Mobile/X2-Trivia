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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: isRevealed ? (answer.isCorrect ? Colors.green : Colors.redAccent) : Colors.black12,
          border: Border.all(color: isSelected ? Colors.deepPurple : Colors.transparent, width: 3),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            answer.text,
            style: isRevealed ? const TextStyle(color: Colors.white, fontWeight: FontWeight.bold) : const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
