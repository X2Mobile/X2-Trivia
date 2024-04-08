import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../data/exceptions/login_exceptions.dart';

class LoginState extends Equatable {
  const LoginState({this.user, this.loading, this.exception});

  final User? user;
  final bool? loading;
  final AuthenticationException? exception;

  LoginState copyWith({User? user, bool? loading, AuthenticationException? exception}) => LoginState(
        user: user,
        loading: loading,
        exception: exception,
      );

  @override
  List<Object?> get props => [user, exception, loading];
}

class SuccessLoginState extends LoginState {
  const SuccessLoginState({
    required User user,
  }) : super(user: user);
}

class ErrorLoginState extends LoginState {
  const ErrorLoginState({
    required AuthenticationException exception,
  }) : super(user: null, exception: exception);
}

class LoadingLoginState extends LoginState {
  const LoadingLoginState() : super(user: null, exception: null, loading: true);
}
