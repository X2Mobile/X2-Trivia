import 'package:equatable/equatable.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class Login extends LoginEvent {
  const Login({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

final class Register extends LoginEvent {
  const Register({
    required this.email,
    required this.password,
    required this.name,
  });

  final String email;
  final String password;
  final String name;

  @override
  List<Object> get props => [email, password];
}
