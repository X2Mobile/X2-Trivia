import 'package:equatable/equatable.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class Login extends LoginEvent {
  const Login({
    required this.email,
  });

  final String email;

  @override
  List<Object> get props => [email,];
}

final class LoginObscureText extends LoginEvent {
  const LoginObscureText();

  @override
  List<Object> get props => [];
}
