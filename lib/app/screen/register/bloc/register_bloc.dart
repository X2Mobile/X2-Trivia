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
  }

  final UserRepository _userRepository;

  Future<void> _onRegister(
    Register event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterLoadingState());
    await emit.forEach<User>(
      _userRepository.createUser(event.name, event.email, event.password),
      onData: (newUser) => RegisterSuccessState(user: newUser),
      onError: (error, stackTrace) {
        AuthenticationException exception = AuthenticationException.firebase(error.toString());
        return RegisterErrorState(exception: exception);
      },
    );
  }
}
