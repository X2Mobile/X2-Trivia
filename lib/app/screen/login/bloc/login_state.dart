import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../data/exceptions/login_exceptions.dart';

class LoginState extends Equatable {
  const LoginState({this.isPasswordVisible = false});

  final bool isPasswordVisible;

  @override
  List<Object> get props => [isPasswordVisible];
}

class LoginSuccessState extends LoginState {
  const LoginSuccessState({
    required isPasswordVisible,
    required this.user,
  }) : super(isPasswordVisible: isPasswordVisible);

  final User user;

  LoginSuccessState.fromState(LoginState state, this.user) : super(isPasswordVisible: state.isPasswordVisible);

  @override
  List<Object> get props => [user, isPasswordVisible];
}

class LoginErrorState extends LoginState {
  const LoginErrorState({
    required isPasswordVisible,
    required this.exception,
  }) : super(isPasswordVisible: isPasswordVisible);

  final AuthenticationException exception;

  LoginErrorState.fromState(LoginState state, this.exception) : super(isPasswordVisible: state.isPasswordVisible);

  @override
  List<Object> get props => [exception, isPasswordVisible];
}

class LoginLoadingState extends LoginState {
  const LoginLoadingState(
    bool isPasswordVisible,
  ) : super(isPasswordVisible: isPasswordVisible);

  LoginLoadingState.fromState(LoginState state) : super(isPasswordVisible: state.isPasswordVisible);
}
