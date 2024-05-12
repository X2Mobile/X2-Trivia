import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:x2trivia/app/screen/app/bloc/app_event.dart';
import 'package:x2trivia/app/screen/app/bloc/app_state.dart';

import '../../../../domain/repositories/user_repository.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const AppState()) {
    on<UserRequestedEvent>(_onUserRequested);
    add(const UserRequestedEvent());
  }

  final UserRepository _userRepository;

  Future<void> _onUserRequested(
    UserRequestedEvent event,
    Emitter<AppState> emit,
  ) async {
    await emit.forEach<User?>(
      _userRepository.getUser(),
      onData: (user) => state.copyWith(user: user),
    );
  }
}
