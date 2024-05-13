import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../data/exceptions/login_exceptions.dart';

class RegisterState extends Equatable {
  const RegisterState({this.isPasswordVisible = false});

  final bool isPasswordVisible;

  @override
  List<Object> get props => [isPasswordVisible];
}

final class RegisterSuccessState extends RegisterState {
  const RegisterSuccessState({
    required isPasswordVisible,
    required this.user,
  }) : super();

  final User user;

  RegisterSuccessState.fromState(RegisterState state, this.user) : super(isPasswordVisible: state.isPasswordVisible);

  @override
  List<Object> get props => [user, isPasswordVisible];
}

final class RegisterErrorState extends RegisterState {
  const RegisterErrorState({
    required this.exception,
  }) : super();

  final AuthenticationException exception;

  @override
  List<Object> get props => [exception];
}

class RegisterLoadingState extends RegisterState {
  const RegisterLoadingState() : super();
}
