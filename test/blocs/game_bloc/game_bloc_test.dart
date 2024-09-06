import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:x2trivia/app/blocs/game/game_bloc.dart';
import 'package:x2trivia/app/blocs/game/game_event.dart';
import 'package:x2trivia/app/blocs/game/game_state.dart';
import 'package:x2trivia/data/utils/demo_data.dart';
import 'package:x2trivia/domain/repositories/questions_repository.dart';

import 'game_bloc_test.mocks.dart';

@GenerateMocks([QuestionsRepository])
void main() {
  group('GameBloc', () {
    late GameBloc gameBloc;
    late MockQuestionsRepository questionsRepository;

    setUp(() {
      questionsRepository = MockQuestionsRepository();
      gameBloc = GameBloc(questionsRepository: questionsRepository);
    });

    // Initial state of the BLOC.
    test('Initial state', () {
      expect(gameBloc.state, const GameUninitialized());
    });

    group('GameQuestionsRequested', () {
      // [GameUninitialized] + SUCCESS.
      blocTest(
        'SUCCESS: emits [GameInitialFetching], [GameInProgress] on GameQuestionsRequested + GameUninitialized.',
        build: () {
          when(questionsRepository.getQuestions(DemoData.kTestCategory)).thenAnswer((realInvocation) async => DemoData.kTestQuestions);
          return gameBloc;
        },
        act: (GameBloc bloc) => bloc.add(GameQuestionsRequested(category: DemoData.kTestCategory)),
        expect: () => [isA<GameInitialFetching>(), isA<GameInProgress>()],
        verify: (GameBloc bloc) => expect(bloc.state, GameInProgress(questions: DemoData.kTestQuestions, category: DemoData.kTestCategory)),
      );

      // [GameUninitialized] + ERROR.
      blocTest(
        'ERROR: emits [GameInitialFetching], [GameInitialFetchingError], [GameUninitialized] on GameQuestionsRequested + GameUninitialized.',
        build: () {
          when(questionsRepository.getQuestions(DemoData.kTestCategory)).thenAnswer((realInvocation) async => throw Error());
          return gameBloc;
        },
        act: (GameBloc bloc) => bloc.add(GameQuestionsRequested(category: DemoData.kTestCategory)),
        expect: () => [
          isA<GameInitialFetching>(),
          isA<GameInitialFetchingError>(),
          isA<GameUninitialized>()
        ],
        verify: (GameBloc bloc) => expect(bloc.state, const GameUninitialized()),
      );
    });
  });
}
