import 'package:cake_it_app/src/router/routes.dart';
import 'package:cake_it_app/src/features/cake/data/cake.dart';
import 'package:cake_it_app/src/features/cake/ui/pages/cake_details_view.dart';
import 'package:cake_it_app/src/features/cake/ui/pages/cake_list_view.dart';
import 'package:go_router/go_router.dart';

import '../features/settings/data/settings_controller.dart';
import '../features/settings/ui/settings_view.dart';

GoRouter createRouter(SettingsController settingsController) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
          name: EnRoutes.cakeListView.name,
          path: '/',
          builder: (context, state) => const CakeListView(),
          routes: [
            GoRoute(
              name: EnRoutes.cakeDetail.name,
              path: 'cake-detail',
              builder: (context, state) {
                final cake = state.extra as Cake;
                return CakeDetailsView(cake: cake);
              },
            )
          ]),
      GoRoute(
        name: EnRoutes.settings.name,
        path: '/settings',
        builder: (context, state) =>
            SettingsView(controller: settingsController),
      ),
    ],
  );
}
