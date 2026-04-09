import 'package:bloc_test/bloc_test.dart';
import 'package:cake_it_app/src/features/cake/data/cake.dart';
import 'package:cake_it_app/src/features/cake/data/cake_repository.dart';
import 'package:cake_it_app/src/features/cake/ui/bloc/cake_cubit.dart';
import 'package:cake_it_app/src/features/cake/ui/bloc/cake_states.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCakeRepository extends Mock implements CakeRepository {}

// Subclass that overrides loadCakes() to a no-op so the constructor doesn't
// fire any async work. Each test can then call loadCakes() / refreshCakes()
// explicitly and observe every emission from a clean CakeLoading baseline.
class _TestCakeCubit extends CakeCubit {
  _TestCakeCubit(super.repository);

  @override
  Future<void> loadCakes() async {
    if (_suppressAutoLoad) return;
    return super.loadCakes();
  }

  bool _suppressAutoLoad = true;

  void enableLoading() => _suppressAutoLoad = false;
}

const _fakeCakes = [
  Cake(
      title: 'Brownie',
      description: 'Rich chocolate',
      image: 'https://example.com/brownie.jpg'),
  Cake(
      title: 'Cheesecake',
      description: 'Creamy',
      image: 'https://example.com/cheesecake.jpg'),
];

void main() {
  late MockCakeRepository repository;

  setUp(() {
    repository = MockCakeRepository();
  });

  _TestCakeCubit buildCubit() => _TestCakeCubit(repository);

  group('loadCakes', () {
    blocTest<_TestCakeCubit, CakeState>(
      'emits [CakeLoading, CakeLoaded] on success',
      build: buildCubit,
      act: (cubit) {
        when(() => repository.fetchCakes()).thenAnswer((_) async => _fakeCakes);
        cubit.enableLoading();
        return cubit.loadCakes();
      },
      expect: () => [
        isA<CakeLoading>(),
        isA<CakeLoaded>().having((s) => s.cakes, 'cakes', _fakeCakes),
      ],
    );

    blocTest<_TestCakeCubit, CakeState>(
      'emits [CakeLoading, CakeError] on failure',
      build: buildCubit,
      act: (cubit) {
        when(() => repository.fetchCakes())
            .thenThrow(const CakeFetchException('network error'));
        cubit.enableLoading();
        return cubit.loadCakes();
      },
      expect: () => [
        isA<CakeLoading>(),
        isA<CakeError>()
            .having((s) => s.message, 'message', 'network error')
            .having((s) => s.hasPreviousData, 'hasPreviousData', false),
      ],
    );

    blocTest<_TestCakeCubit, CakeState>(
      'emits [CakeLoading, CakeLoaded] when retrying after an error',
      build: buildCubit,
      act: (cubit) async {
        cubit.enableLoading();
        when(() => repository.fetchCakes())
            .thenThrow(const CakeFetchException('oops'));
        await cubit.loadCakes();

        when(() => repository.fetchCakes()).thenAnswer((_) async => _fakeCakes);
        await cubit.loadCakes();
      },
      expect: () => [
        isA<CakeLoading>(),
        isA<CakeError>(),
        isA<CakeLoading>(),
        isA<CakeLoaded>().having((s) => s.cakes, 'cakes', _fakeCakes),
      ],
    );
  });

  group('refreshCakes', () {
    blocTest<_TestCakeCubit, CakeState>(
      'emits [CakeRefreshing, CakeLoaded] when called from CakeLoaded',
      build: buildCubit,
      act: (cubit) async {
        when(() => repository.fetchCakes()).thenAnswer((_) async => _fakeCakes);
        cubit.enableLoading();
        await cubit.loadCakes();
        await cubit.refreshCakes();
      },
      expect: () => [
        isA<CakeLoading>(),
        isA<CakeLoaded>(),
        isA<CakeRefreshing>().having((s) => s.cakes, 'cakes', _fakeCakes),
        isA<CakeLoaded>().having((s) => s.cakes, 'cakes', _fakeCakes),
      ],
    );

    blocTest<_TestCakeCubit, CakeState>(
      'preserves previous cakes in CakeError when refresh fails',
      build: buildCubit,
      act: (cubit) async {
        when(() => repository.fetchCakes()).thenAnswer((_) async => _fakeCakes);
        cubit.enableLoading();
        await cubit.loadCakes();

        when(() => repository.fetchCakes())
            .thenThrow(const CakeFetchException('refresh failed'));
        await cubit.refreshCakes();
      },
      expect: () => [
        isA<CakeLoading>(),
        isA<CakeLoaded>(),
        isA<CakeRefreshing>().having((s) => s.cakes, 'cakes', _fakeCakes),
        isA<CakeError>()
            .having((s) => s.message, 'message', 'refresh failed')
            .having((s) => s.previousCakes, 'previousCakes', _fakeCakes)
            .having((s) => s.hasPreviousData, 'hasPreviousData', true),
      ],
    );

    blocTest<_TestCakeCubit, CakeState>(
      'carries empty previousCakes when refreshing from initial error state',
      build: buildCubit,
      act: (cubit) async {
        when(() => repository.fetchCakes())
            .thenThrow(const CakeFetchException('initial error'));
        cubit.enableLoading();
        await cubit.loadCakes();

        when(() => repository.fetchCakes())
            .thenThrow(const CakeFetchException('refresh error'));
        await cubit.refreshCakes();
      },
      expect: () => [
        isA<CakeLoading>(),
        isA<CakeError>()
            .having((s) => s.hasPreviousData, 'hasPreviousData', false),
        isA<CakeRefreshing>().having((s) => s.cakes, 'cakes', isEmpty),
        isA<CakeError>()
            .having((s) => s.message, 'message', 'refresh error')
            .having((s) => s.hasPreviousData, 'hasPreviousData', false),
      ],
    );
  });

  group('CakeError', () {
    test('hasPreviousData is false when previousCakes is empty', () {
      const state = CakeError(message: 'oops');
      expect(state.hasPreviousData, isFalse);
    });

    test('hasPreviousData is true when previousCakes has items', () {
      const state = CakeError(message: 'oops', previousCakes: _fakeCakes);
      expect(state.hasPreviousData, isTrue);
    });
  });
}
