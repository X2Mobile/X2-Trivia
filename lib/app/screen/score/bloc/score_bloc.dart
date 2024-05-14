import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:x2trivia/app/screen/score/bloc/score_event.dart';
import 'package:x2trivia/app/screen/score/bloc/score_state.dart';
import 'package:x2trivia/domain/models/score.dart';
import 'package:x2trivia/domain/repositories/score_repository.dart';
import 'package:x2trivia/domain/repositories/user_repository.dart';

class ScoreBloc extends Bloc<ScoreEvent, ScoreState> {
  ScoreBloc({
    required this.userRepository,
    required this.scoreRepository,
    required category,
    required score,
  }) : super(ScoreInitial(score, category)) {
    on<ScoreSave>(_onSaveScore);
  }

  final UserRepository userRepository;
  final ScoreRepository scoreRepository;

  Future<void> _onSaveScore(
    ScoreSave event,
    Emitter<ScoreState> emit,
  ) async {
    emit(ScoreLoadInProgress.fromState(state));
    try {
      User? currentUser = await userRepository.getUser().first;
      await scoreRepository.addScore(
        Score(
            email: currentUser!.email!,
            name: currentUser.displayName!,
            categoryId: state.category.id,
            score: state.score,
            date: DateTime.now()),
      );
      emit(ScoreLoadSuccess.fromState(state));
    } catch (error) {
      emit(ScoreLoadError.fromState(state, error.toString()));
    }
  }
}
