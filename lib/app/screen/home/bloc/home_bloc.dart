import 'package:bloc/bloc.dart';
import 'package:x2trivia/app/screen/home/bloc/home_event.dart';
import 'package:x2trivia/app/screen/home/bloc/home_state.dart';

import '../../../../domain/repositories/user_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required UserRepository userRepository,
    String? userDisplayName,
  })  : _userRepository = userRepository,
        super(HomeState(userDisplayName: userDisplayName)) {
    on<SignOutEvent>(_onSignOut);
  }

  final UserRepository _userRepository;

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<HomeState> emit,
  ) async {
    await _userRepository.logoutUser();
    emit(state.copyWith(
      user: null,
    ));
  }
}
