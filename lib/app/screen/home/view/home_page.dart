import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:x2trivia/app/screen/categories/view/categories_page.dart';
import 'package:x2trivia/app/screen/leaderboard/view/leaderboard_page.dart';

import '../../../../domain/repositories/user_repository.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route<void> route({String? user}) => MaterialPageRoute(
    builder: (context) => BlocProvider(
      create: (BuildContext context) => HomeBloc(
        userRepository: context.read<UserRepository>(),
        user: user,
      ),
      child: const HomePageView(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeBloc(
        userRepository: context.read<UserRepository>(),
      ),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (_, state) {
          return const HomePageView();
        },
      ),
    );
  }
}

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  late final HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();
    homeBloc = context.read<HomeBloc>();
  }

  void _onSignOut() async {
    showDialog(
      context: context,
      builder: (context) => signOutConfirmation(context),
    );
  }

  void _onSignOutConfirmation() {
    homeBloc.add(const SignOutEvent());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    HomeState state = context.watch<HomeBloc>().state;
    String username = state.user.toString();

    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.x2Trivia,
                  style: TextStyle(
                    fontSize: 42,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                      onPressed: () => Navigator.of(context, rootNavigator: true).push(CategoriesPage.route()),
                      child: Text(AppLocalizations.of(context)!.startGame)
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                      onPressed: () => Navigator.of(context, rootNavigator: true).push(LeaderboardPage.route()),
                      child: Text(AppLocalizations.of(context)!.leaderboard)
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(AppLocalizations.of(context)!.signedIn),
                          Expanded(
                            child: Text(
                              username,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => _onSignOut(),
                      child: Text(AppLocalizations.of(context)!.signOut),
                    ),
                  ],
                ),
              ]
          ),
        )
    );
  }

  Widget signOutConfirmation(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.signOutConfirmation),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () => _onSignOutConfirmation(),
          child: Text(AppLocalizations.of(context)!.signOut),
        ),
      ],
    );
  }
}
