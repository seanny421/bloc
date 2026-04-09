import 'package:cake_it_app/src/features/cake/data/cake.dart';
import 'package:cake_it_app/src/features/cake/data/cake_repository.dart';
import 'package:cake_it_app/src/features/cake/ui/bloc/cake_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CakeCubit extends Cubit<CakeState> {
  final CakeRepository _repository;

  CakeCubit(this._repository) : super(const CakeLoading()) {
    loadCakes();
  }

  Future<void> loadCakes() async {
    emit(const CakeLoading());

    await _fetchAndEmit(previousCakes: []);
  }

  Future<void> refreshCakes() async {
    final List<Cake> currentCakes = switch (state) {
      CakeLoaded(:final cakes) => cakes,
      CakeRefreshing(:final cakes) => cakes,
      CakeError(:final previousCakes) => previousCakes,
      CakeLoading() => [],
    };

    emit(CakeRefreshing(currentCakes));
    await _fetchAndEmit(previousCakes: currentCakes);
  }

  Future<void> _fetchAndEmit({required List<Cake> previousCakes}) async {
    try {
      final cakes = await _repository.fetchCakes();
      emit(CakeLoaded(cakes));
    } on CakeFetchException catch (e) {
      emit(CakeError(message: e.message, previousCakes: previousCakes));
    }
  }
}
