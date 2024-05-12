import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../data/exceptions/login_exceptions.dart';

class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginSuccessState extends LoginState {
  const LoginSuccessState({
    required this.user,
  }) : super();

  final User user;

  @override
  List<Object?> get props => [user];
}

class LoginErrorState extends LoginState {
  const LoginErrorState({
    required this.exception,
  }) : super();

  final AuthenticationException exception;

  @override
  List<Object?> get props => [exception];
}

class LoginLoadingState extends LoginState {
  const LoginLoadingState() : super();
}
