import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          title: Text(AppLocalizations.of(context)!.leaderboard),
        ),
        body: Center(
            child: Text(AppLocalizations.of(context)!.leaderboard)
        )
    );
  }
}
