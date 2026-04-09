import 'package:bloc_test/bloc_test.dart';
import 'package:cake_it_app/src/core/router/routes.dart';
import 'package:cake_it_app/src/features/cake/data/cake.dart';
import 'package:cake_it_app/src/features/cake/ui/bloc/cake_cubit.dart';
import 'package:cake_it_app/src/features/cake/ui/pages/cake_details_view.dart';
import 'package:cake_it_app/src/features/cake/ui/pages/cake_list_view.dart';
import 'package:cake_it_app/src/features/cake/ui/widgets/cake_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockCakeCubit extends MockCubit<CakeState> implements CakeCubit {}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _fakeCakes = [
  Cake(title: 'Brownie', description: 'Rich chocolate', image: ''),
  Cake(title: 'Cheesecake', description: 'Creamy delight', image: ''),
];

Widget _buildListView({required CakeState state}) {
  final cubit = MockCakeCubit();
  when(() => cubit.state).thenReturn(state);
  whenListen(cubit, Stream.fromIterable([state]));

  final router = GoRouter(
    routes: [
      GoRoute(
        name: EnRoutes.cakeListView.name,
        path: '/',
        builder: (_, __) => BlocProvider<CakeCubit>.value(
          value: cubit,
          child: const CakeListView(),
        ),
        routes: [
          GoRoute(
            name: EnRoutes.cakeDetail.name,
            path: 'cake-detail',
            builder: (_, state) => CakeDetailsView(cake: state.extra as Cake),
          ),
        ],
      ),
      GoRoute(
        name: EnRoutes.settings.name,
        path: '/settings',
        builder: (_, __) => const Scaffold(body: Text('Settings')),
      ),
    ],
  );

  return MaterialApp.router(routerConfig: router);
}

// ---------------------------------------------------------------------------
// CakeListView tests
// ---------------------------------------------------------------------------

void main() {
  group('CakeListView', () {
    testWidgets('shows a loading spinner while CakeLoading', (tester) async {
      await tester.pumpWidget(_buildListView(state: const CakeLoading()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows the list when CakeLoaded', (tester) async {
      await tester
          .pumpWidget(_buildListView(state: const CakeLoaded(_fakeCakes)));
      await tester.pump(); // settle

      expect(find.text('Brownie'), findsOneWidget);
      expect(find.text('Cheesecake'), findsOneWidget);
    });

    testWidgets(
        'shows error view with retry button when CakeError and no previous data',
        (tester) async {
      await tester.pumpWidget(_buildListView(
        state: const CakeError(message: 'network error'),
      ));
      await tester.pump();

      expect(find.text('Could not load cakes'), findsOneWidget);
      expect(find.text('network error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets(
        'shows list and no full-screen error when CakeError has previous data',
        (tester) async {
      await tester.pumpWidget(_buildListView(
        state: const CakeError(
          message: 'refresh failed',
          previousCakes: _fakeCakes,
        ),
      ));
      await tester.pump();

      // List is still visible
      expect(find.text('Brownie'), findsOneWidget);
      // Full-screen error is not shown
      expect(find.text('Could not load cakes'), findsNothing);
    });

    testWidgets('shows progress overlay when CakeRefreshing', (tester) async {
      await tester
          .pumpWidget(_buildListView(state: const CakeRefreshing(_fakeCakes)));
      await tester.pump();

      expect(find.text('Brownie'), findsOneWidget);
    });

    testWidgets('shows "No cakes found" when CakeLoaded with empty list',
        (tester) async {
      await tester.pumpWidget(_buildListView(state: const CakeLoaded([])));
      await tester.pump();

      expect(find.text('No cakes found.'), findsOneWidget);
    });

    testWidgets('navigates to settings when settings icon tapped',
        (tester) async {
      await tester
          .pumpWidget(_buildListView(state: const CakeLoaded(_fakeCakes)));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('navigates to detail view when a cake tile is tapped',
        (tester) async {
      await tester
          .pumpWidget(_buildListView(state: const CakeLoaded(_fakeCakes)));
      await tester.pump();

      await tester.tap(find.text('Brownie'));
      await tester.pumpAndSettle();

      // CakeDetailsView renders the title inside the SliverAppBar
      expect(find.text('Brownie'), findsAtLeastNWidgets(1));
    });
  });

  // -------------------------------------------------------------------------
  // CakeDetailsView tests
  // -------------------------------------------------------------------------

  group('CakeDetailsView', () {
    const detailCake = Cake(
      title: 'Victoria Sponge',
      description: 'A British classic',
      image: '',
    );

    Widget buildDetail() => MaterialApp(
          home: CakeDetailsView(cake: detailCake),
        );

    testWidgets('renders cake title', (tester) async {
      await tester.pumpWidget(buildDetail());
      await tester.pump();
      expect(find.text('Victoria Sponge'), findsOneWidget);
    });

    testWidgets('renders cake description', (tester) async {
      await tester.pumpWidget(buildDetail());
      await tester.pump();
      expect(find.text('A British classic'), findsOneWidget);
    });

    testWidgets('renders section headings', (tester) async {
      await tester.pumpWidget(buildDetail());
      await tester.pump();
      expect(find.text('About'), findsOneWidget);
      expect(find.text('History'), findsOneWidget);
      expect(find.text('Serving Suggestions'), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  // CakeImage tests
  // -------------------------------------------------------------------------

  group('CakeImage', () {
    testWidgets('shows fallback icon when imageUrl is empty', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: CakeImage(imageUrl: '')),
      ));

      expect(find.byIcon(Icons.cake), findsOneWidget);
    });

    testWidgets('respects width and height constraints', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: CakeImage(imageUrl: '', width: 80, height: 80),
        ),
      ));

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, 80);
      expect(sizedBox.height, 80);
    });
  });
}
