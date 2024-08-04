import 'package:bloc/bloc.dart';
import 'package:x2trivia/app/blocs/game/game_bloc_handler.dart';
import 'package:x2trivia/app/blocs/game/game_event.dart';
import 'package:x2trivia/app/blocs/game/game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({
    questionsRepository,
  }) : super(const GameUninitialized()) {
    handler = GameBlocHandler(questionsRepository: questionsRepository);

    on<GameQuestionsRequested>(_onGameQuestionsRequested);
    on<GamePause>(_onGamePause);
    on<GameResume>(_onGameResume);
    on<GameAnswerSelect>(_onSelectAnswer);
    on<GameAnswerUnselect>(_onUnselectAnswer);
    on<GameValidateAnswerEvent>(_onGameValidateAnswerEvent);
    on<GameSubmitAnswerEvent>(_onGameSubmitAnswerEvent);
  }

  late GameBlocHandler handler;

  Future<void> _onGameQuestionsRequested(
    GameQuestionsRequested event,
    Emitter<GameState> emit,
  ) {
    return _handleStatesOnEvent(
      isNoOp: state is GameInitialFetching || state is GameInitialFetchingError,
      onGameUninitialized: () => handler.onGameQuestionsRequested(event, const GameUninitialized(), emit),
      onGameInitialized: () => handler.onGameQuestionsRequested(event, const GameUninitialized(), emit),
    );
  }

  Future<void> _onGamePause(
    GamePause event,
    Emitter<GameState> emit,
  ) {
    return _handleStatesOnEvent(
      isNoOp: state is! GameInProgress,
      onGameInitialized: () => handler.onGamePaused(
        event,
        state as GameInProgress,
        emit,
      ),
    );
  }

  Future<void> _onGameResume(
    GameResume event,
    Emitter<GameState> emit,
  ) {
    return _handleStatesOnEvent(
      isNoOp: state is! GamePaused,
      onGameInitialized: () => handler.onGameResume(
        event,
        state as GamePaused,
        emit,
      ),
    );
  }

  Future<void> _onSelectAnswer(
    GameAnswerSelect event,
    Emitter<GameState> emit,
  ) =>
      _handleStatesOnEvent(
        isNoOp: state is! GameInProgress,
        onGameInitialized: () => handler.onSelectAnswer(
          event,
          state as GameInProgress,
          emit,
        ),
      );

  Future<void> _onUnselectAnswer(
    GameAnswerUnselect event,
    Emitter<GameState> emit,
  ) =>
      _handleStatesOnEvent(
        isNoOp: state is! GameInProgress,
        onGameInitialized: () => handler.onUnselectAnswer(
          event,
          state as GameInProgress,
          emit,
        ),
      );

  Future<void> _onGameValidateAnswerEvent(
    GameValidateAnswerEvent event,
    Emitter<GameState> emit,
  ) =>
      _handleStatesOnEvent(
        isNoOp: state is! GameInProgress,
        onGameInitialized: () => handler.onGameValidateAnswerEvent(
          event,
          state as GameInProgress,
          emit,
        ),
      );

  Future<void> _onGameSubmitAnswerEvent(
    GameSubmitAnswerEvent event,
    Emitter<GameState> emit,
  ) =>
      _handleStatesOnEvent(
        isNoOp: state is! GameInProgress,
        onGameInitialized: () => handler.onGameSubmitAnswerEvent(
          event,
          state as GameInProgress,
          emit,
        ),
      );

  Future<void> _handleStatesOnEvent({
    required bool isNoOp,
    Function()? onGameInitialized,
    Function()? onGameUninitialized,
  }) async {
    if (isNoOp) {
      return;
    } else if (state is GameUninitialized || state is GameEnded) {
      assert(onGameUninitialized != null, "Missing onGameUninitialized");
      await onGameUninitialized!();
    } else if (state is GameActive) {
      assert(onGameInitialized != null, "Missing onGameInitialized");
      await onGameInitialized!();
    } else {
      throw UnimplementedError("No handler");
    }
  }
}
