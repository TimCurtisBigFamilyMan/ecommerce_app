@Timeout(Duration(milliseconds: 500))

import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks.dart';

void main() {
  group('AccountScreenController', () {
    late MockAuthRepository authRepository;
    late AccountScreenController controller;
    setUp(() {
      authRepository = MockAuthRepository();
      controller = AccountScreenController(authRepository: authRepository);
    });
    test('initial state is AsyncValue.data', () {
      // setup
      // All setUp is now done inside the setUp method.
      // verify
      verifyNever(authRepository.signOut);
      expect(controller.debugState, const AsyncData<void>(null));
    });

    test(
      'signOut success',
      () async {
        // setup
        when(authRepository.signOut).thenAnswer(
          (_) => Future.value(),
        );
        // expect later / Stream verify
        expectLater(
          controller.stream,
          emitsInOrder(const [AsyncLoading<void>(), AsyncData<void>(null)]),
        );
        // run
        await controller.signOut();
        // verify
        verify(authRepository.signOut).called(1);
        expect(controller.debugState, const AsyncData<void>(null));
      },
    );

    test(
      'signOut failure',
      () async {
        // setup
        final exception = Exception('Connection failed');
        when(authRepository.signOut).thenThrow(exception);
        // final controller =
        //     AccountScreenController(authRepository: authRepository);
        // expect later / Stream verify
        expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<void>(),
            predicate<AsyncValue<void>>((value) {
              expect(value.hasError, true);
              return true;
            }),
          ]),
        );
        // run
        await controller.signOut();
        // verify
        verify(authRepository.signOut).called(1);
        expect(controller.debugState.hasError, true);
        expect(controller.debugState, isA<AsyncError>());
      },
    );
  });
}
