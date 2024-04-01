import 'package:flutter/material.dart';
import 'package:x2trivia/domain/models/category.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  static Route<void> route({
    required Category category
  }) => MaterialPageRoute(
    builder: (context) => const GamePage(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Game"),
        ),
        body: Center(
            child: Text("Game")
        )
    );
  }
}