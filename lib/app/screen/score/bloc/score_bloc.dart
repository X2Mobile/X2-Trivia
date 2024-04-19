import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:x2trivia/app/screen/score/bloc/score_event.dart';
import 'package:x2trivia/app/screen/score/bloc/score_state.dart';
import 'package:x2trivia/domain/models/score.dart';
import 'package:x2trivia/domain/repositories/firestore_repository.dart';
import 'package:x2trivia/domain/repositories/user_repository.dart';

import '../../../../domain/models/category.dart';

class ScoreBloc extends Bloc<ScoreEvent, ScoreState> {
  ScoreBloc({
    required this.userRepository,
    required this.firestoreRepository,
    required this.category,
    required this.score,
  }) : super(const ScoreState()) {
    on<SaveScoreEvent>(_onSaveScore);
  }

  final UserRepository userRepository;
  final FirestoreRepository firestoreRepository;
  final Category category;
  final int score;

  Future<void> _onSaveScore(SaveScoreEvent event, Emitter<ScoreState> emit) async {
    emit(const LoadingScoreState());
    try {
      User? currentUser = await userRepository.getUser().first;
      await firestoreRepository.addScore(
        Score(
            email: currentUser!.email!,
            name: currentUser.displayName!,
            categoryId: category.id,
            score: score,
            date: DateTime.now()),
      );
      emit(const SuccessScoreState());
    } catch (error) {
      emit(ErrorScoreState(exception: error.toString()));
    }
  }
}
