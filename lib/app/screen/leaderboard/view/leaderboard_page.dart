import 'package:flutter/material.dart';
import 'package:x2trivia/app/util/build_context_helper.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  static Route<void> route() => MaterialPageRoute(
        builder: (context) => const LeaderboardPage(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(context.strings.leaderboard),
        ),
        body: Center(child: Text(context.strings.leaderboard)));
  }
}
