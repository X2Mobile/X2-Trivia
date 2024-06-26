import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:x2trivia/app/screen/home/view/home_page.dart';
import 'package:x2trivia/app/screen/login/view/login_page.dart';
import 'package:x2trivia/app/theme/theme.dart';
import 'package:x2trivia/domain/repositories/questions_repository.dart';
import 'package:x2trivia/domain/repositories/score_repository.dart';
import 'package:x2trivia/domain/repositories/user_repository.dart';

import '../bloc/app_bloc.dart';
import '../bloc/app_state.dart';

class TriviaApp extends StatelessWidget {
  final UserRepository _userRepository;
  final ScoreRepository _scoreRepository;
  final QuestionsRepository _questionsRepository;

  const TriviaApp(this._userRepository, this._scoreRepository, this._questionsRepository, {super.key});

  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => _userRepository),
          RepositoryProvider(create: (context) => _scoreRepository),
          RepositoryProvider(create: (context) => _questionsRepository),
        ],
        child: BlocProvider(
          create: (context) => AppBloc(userRepository: _userRepository),
          child: const AppView(),
        ),
      );
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppState();
}

class _AppState extends State<AppView> {
  late final AppBloc appBloc;

  @override
  void initState() {
    super.initState();

    appBloc = context.read<AppBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'X2 Trivia Game',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
        ],
        theme: X2TriviaTheme.lightTheme,
        home: BlocBuilder<AppBloc, AppState>(builder: (_, state) {
          return state.user == null ? const LoginPage() : HomePage(state.user!.displayName);
        }));
  }
}
