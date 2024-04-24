import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:x2trivia/app/screen/app/view/app_page.dart';
import 'package:x2trivia/data/data_user_repository.dart';
import 'package:x2trivia/data/data_firestore_repository.dart';

import 'app/util/app_bloc_observer.dart';
import 'firebase_options.dart';

void bootstrap() {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // TODO add repositories
  final userRepository = DataUserRepository();
  final firestoreRepository = DataScoreRepository();

  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    runApp(TriviaApp(
      userRepository,
      firestoreRepository,
    ));
  }, (error, stackTrace) {
    log('runZonedGuarded: Caught error', error: error, stackTrace: stackTrace);
  });
}
