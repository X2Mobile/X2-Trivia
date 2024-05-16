import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:x2trivia/app/screen/categories/view/categories_page.dart';
import 'package:x2trivia/app/screen/leaderboard/view/leaderboard_page.dart';
import 'package:x2trivia/app/util/build_context_helper.dart';
import 'package:x2trivia/gen/assets.gen.dart';

import '../../../../domain/repositories/user_repository.dart';
import '../../login/view/login_page.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage(this.displayName, {super.key});

  final String? displayName;

  static Route<void> route({String? userDisplayName}) => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (BuildContext context) => HomeBloc(
            userRepository: context.read<UserRepository>(),
            userDisplayName: userDisplayName,
          ),
          child: const HomePageView(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeBloc(
        userRepository: context.read<UserRepository>(),
        userDisplayName: displayName,
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
    Navigator.of(context).pushAndRemoveUntil(LoginPage.route(), (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            homeImage(),
            newGameButton(),
            const SizedBox(height: 8),
            leaderboardButton(),
            const SizedBox(height: 32),
            ...homeFooter(),
          ],
        ),
      ),
    );
  }

  Widget homeImage() => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SvgPicture.asset(Assets.icons.x2logoHome),
        ),
      );

  Widget newGameButton() => SizedBox(
    width: double.infinity,
    child: FilledButton(
      //todo navigheaza la category page
      onPressed: () {},
      child: Text(context.strings.newGame),
    ),
  );

  Widget leaderboardButton() => SizedBox(
    width: double.infinity,
    child: FilledButton.tonal(
      //todo navigheaza la leaerboard page
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events_outlined, size: 18),
          const SizedBox(width: 8),
          Text(context.strings.leaderboard),
        ],
      ),
    ),
  );

  List<Widget> homeFooter() => [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      context.strings.signedIn,
                      style: TextStyle(color: Theme.of(context).colorScheme.outline),
                    ),
                    Expanded(
                      child: BlocBuilder<HomeBloc, HomeState>(
                        builder: (_, state) {
                          return Text(
                            state.userDisplayName.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: _onSignOut,
                child: Text(
                  context.strings.signOut,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
        ),
      ];

  Widget signOutConfirmation(BuildContext context) {
    return AlertDialog(
      title: Text(context.strings.signOutConfirmation),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.strings.cancel),
        ),
        TextButton(
          onPressed: _onSignOutConfirmation,
          child: Text(context.strings.signOut),
        ),
      ],
    );
  }
}
