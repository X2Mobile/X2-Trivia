import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:x2trivia/app/screen/app/view/app_page.dart';
import 'package:x2trivia/data/data_score_repository.dart';
import 'package:x2trivia/data/data_user_repository.dart';

import 'app/theme/theme.dart';
import 'app/util/app_bloc_observer.dart';
import 'firebase_options.dart';

void bootstrap() {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  final userRepository = DataUserRepository();
  final scoreRepository = DataScoreRepository();

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(X2TriviaTheme.systemUiOverlayStyle);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    runApp(TriviaApp(
      userRepository,
      scoreRepository,
    ));
  }, (error, stackTrace) {
    log('runZonedGuarded: Caught error', error: error, stackTrace: stackTrace);
  });
}
