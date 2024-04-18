import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../data/exceptions/login_exceptions.dart';
import '../../../../domain/repositories/user_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const LoginState(loading: false)) {
    on<Login>(_onLogin);
    on<Register>(_onRegister);
  }

  final UserRepository _userRepository;

  Future<void> _onLogin(
    Login event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoadingLoginState());
    await emit.forEach<User>(
      _userRepository.loginUser(event.email, event.password),
      onData: (newUser) {
        return SuccessLoginState(user: newUser);
      },
      onError: (error, stackTrace) {
        AuthenticationException exception = error as AuthenticationException;
        return ErrorLoginState(exception: exception);
      },
    );
  }

  Future<void> _onRegister(
    Register event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoadingLoginState());
    await emit.forEach<User>(
      _userRepository.createUser(event.name, event.email, event.password),
      onData: (newUser) {
        return SuccessLoginState(user: newUser);
      },
      onError: (error, stackTrace) {
        AuthenticationException exception = AuthenticationException.firebase(error.toString());
        return ErrorLoginState(exception: exception);
      },
    );
  }
}
