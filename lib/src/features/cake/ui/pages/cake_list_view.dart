import 'package:cake_it_app/src/features/cake/ui/widgets/cake_image.dart';
import 'package:cake_it_app/src/router/routes.dart';
import 'package:cake_it_app/src/features/cake/data/cake.dart';
import 'package:cake_it_app/src/features/cake/ui/bloc/cake_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Displays a list of cakes.
/// Hmmm Stateful Widget is used here, but it could be a StatelessWidget?
///
/// Leaving this as Stateful so we don't call the loadcakes every time we rebuild
class CakeListView extends StatelessWidget {
  const CakeListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎂CakeItApp🍰'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.pushNamed(EnRoutes.settings.name);
            },
          ),
        ],
      ),
      body: BlocConsumer<CakeCubit, CakeState>(
        listener: (context, state) {
          if (state is CakeError && state.hasPreviousData) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text('Refresh failed: ${state.message}'),
                action: SnackBarAction(
                    label: 'Retry',
                    onPressed: context.read<CakeCubit>().refreshCakes),
              ));
          }
        },
        builder: (context, state) {
          return switch (state) {
            CakeLoading() => const _LoadingView(),
            CakeError(:final message, hasPreviousData: false) => _ErrorView(
                message: message,
                onRetry: context.read<CakeCubit>().loadCakes,
              ),
            CakeLoaded(:final cakes) => _CakeList(
                cakes: cakes,
                isRefreshing: false,
              ),
            CakeRefreshing(:final cakes) =>
              _CakeList(cakes: cakes, isRefreshing: true),
            CakeError(:final previousCakes) =>
              _CakeList(cakes: previousCakes, isRefreshing: false)
          };
        },
      ),
    );
  }
}

class _CakeList extends StatelessWidget {
  const _CakeList({required this.cakes, required this.isRefreshing});

  final List<Cake> cakes;

  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    if (cakes.isEmpty) {
      return const Center(child: Text('No cakes found.'));
    }

    return RefreshIndicator.adaptive(
      // Delegates to the cubit — the cubit decides how to update state.
      onRefresh: context.read<CakeCubit>().refreshCakes,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ListView.builder(
          restorationId: 'cakeListView',
          // Required so the RefreshIndicator is reachable even when the list
          // does not fill the viewport.
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: cakes.length,
          itemBuilder: (context, index) => _CakeTile(cake: cakes[index]),
        ),
      ),
    );
  }
}

class _CakeTile extends StatelessWidget {
  const _CakeTile({required this.cake});

  final Cake cake;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.goNamed(EnRoutes.cakeDetail.name, extra: cake),
        child: Row(
          children: [
            CakeImage(
              imageUrl: cake.image,
              width: 70,
              height: 70,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cake.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cake.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator.adaptive());
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48),
            const SizedBox(height: 16),
            Text(
              'Could not load cakes',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
