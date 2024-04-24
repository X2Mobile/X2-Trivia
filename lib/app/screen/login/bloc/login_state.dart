import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../data/exceptions/login_exceptions.dart';

class LoginState extends Equatable {
  const LoginState({this.loading = false});

  final bool loading;

  @override
  List<Object?> get props => [loading];
}

class SuccessLoginState extends LoginState {
  const SuccessLoginState({
    required this.user,
  }) : super();

  final User user;

  @override
  List<Object?> get props => [user];
}

class ErrorLoginState extends LoginState {
  const ErrorLoginState({
    required this.exception,
  }) : super();

  final AuthenticationException exception;

  @override
  List<Object?> get props => [exception];
}

class LoadingLoginState extends LoginState {
  const LoadingLoginState() : super(loading: true);
}
