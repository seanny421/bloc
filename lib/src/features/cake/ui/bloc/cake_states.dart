import 'package:cake_it_app/src/features/cake/data/cake.dart';

sealed class CakeState {
  const CakeState();
}

final class CakeLoading extends CakeState {
  const CakeLoading();
}

final class CakeLoaded extends CakeState {
  final List<Cake> cakes;

  const CakeLoaded(this.cakes);
}

final class CakeError extends CakeState {
  final String message;
  final List<Cake> previousCakes;

  const CakeError({required this.message, this.previousCakes = const []});

  bool get hasPreviousData => previousCakes.isNotEmpty;
}

final class CakeRefreshing extends CakeState {
  const CakeRefreshing(this.cakes);

  final List<Cake> cakes;
}
