import 'package:bloc/bloc.dart';
import 'package:x2trivia/app/screen/score/bloc/score_event.dart';
import 'package:x2trivia/app/screen/score/bloc/score_state.dart';
import 'package:x2trivia/domain/repositories/user_repository.dart';

import '../../../../domain/models/category.dart';

class ScoreBloc extends Bloc<ScoreEvent, ScoreState> {
  ScoreBloc({
    required this.userRepository,
    required this.category,
    required this.score,
  })  : super(const ScoreState()) {
    on<SaveScoreEvent>(_onSaveScore);
  }

  final UserRepository userRepository;
  final Category category;
  final int score;

  Future<void> _onSaveScore(SaveScoreEvent event, Emitter<ScoreState> emit) async {
    emit(const SuccessScoreState());
  }
}
