import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:x2trivia/app/screen/register/bloc/register_event.dart';
import 'package:x2trivia/app/screen/register/bloc/register_state.dart';

import '../../../../data/exceptions/login_exceptions.dart';
import '../../../../domain/repositories/user_repository.dart';

final class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const RegisterState()) {
    on<Register>(_onRegister);
    on<RegisterObscureText>(_onObscureText);
  }

  final UserRepository _userRepository;

  Future<void> _onRegister(
    Register event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterLoadingState());
    await emit.forEach<User>(
      _userRepository.createUser(event.name, event.email, event.password),
      onData: (newUser) => RegisterSuccessState.fromState(state, newUser),
      onError: (error, stackTrace) {
        AuthenticationException exception = AuthenticationException.firebase((error as AuthenticationException).message());
        return RegisterErrorState.fromState(state, exception);
      },
    );
  }

  Future<void> _onObscureText(
    RegisterObscureText event,
    Emitter<RegisterState> emit,
  ) async =>
      emit(RegisterState(isPasswordVisible: !state.isPasswordVisible));
}
