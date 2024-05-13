import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  final String logName = 'BlocObserver';

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log('Event: $event', name: logName, time: DateTime.now(), zone: Zone.current);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('Change: $change', name: logName, time: DateTime.now(), zone: Zone.current);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log('Transition: $transition', name: logName, time: DateTime.now(), zone: Zone.current);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    log('Error: $error\nStackTrace: $stackTrace', name: logName, time: DateTime.now(), zone: Zone.current);
  }
}
