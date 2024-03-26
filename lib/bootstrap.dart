import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:x2trivia/app/app.dart';
import 'package:x2trivia/domain/repositories/user_repository.dart';

import 'app/util/app_bloc_observer.dart';

void bootstrap() {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // TODO add repositories
  final userRepository = UserRepositoryImpl();

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    runApp(TriviaApp(
      userRepository,
    ));
  }, (error, stackTrace) {
    log('runZonedGuarded: Caught error', error: error, stackTrace: stackTrace);
  });
}
