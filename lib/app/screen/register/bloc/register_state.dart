import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../data/exceptions/login_exceptions.dart';

class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

final class RegisterSuccessState extends RegisterState {
  const RegisterSuccessState({
    required this.user,
  }) : super();

  final User user;

  @override
  List<Object?> get props => [user];
}

final class RegisterErrorState extends RegisterState {
  const RegisterErrorState({
    required this.exception,
  }) : super();

  final AuthenticationException exception;

  @override
  List<Object?> get props => [exception];
}

class RegisterLoadingState extends RegisterState {
  const RegisterLoadingState() : super();
}
