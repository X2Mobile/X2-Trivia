import 'package:equatable/equatable.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

final class Register extends RegisterEvent {
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

final class RegisterObscureText extends RegisterEvent {
  const RegisterObscureText();

  @override
  List<Object> get props => [];
}
