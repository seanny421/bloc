import 'package:cake_it_app/src/features/cake/ui/bloc/cake_cubit.dart';
import 'package:cake_it_app/src/features/cake/ui/pages/cake_details_view.dart';
import 'package:cake_it_app/src/features/cake/ui/pages/cake_list_view.dart';
import 'package:cake_it_app/src/features/cake/data/cake_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'localization/app_localizations.dart';
import 'features/settings/data/settings_controller.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
    required this.router,
  });

  final SettingsController settingsController;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<CakeRepository>(
      create: (_) => CakeRepository(),
      child: BlocProvider(
        create: (context) => CakeCubit(context.read<CakeRepository>()),
        child: ListenableBuilder(
            listenable: settingsController,
            builder: (context, _) {
              return MaterialApp.router(
                routerConfig: router,
                debugShowCheckedModeBanner: false,
                restorationScopeId: 'app',
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en', ''), // English, no country code
                ],
                onGenerateTitle: (BuildContext context) =>
                    AppLocalizations.of(context)!.appTitle,
                theme: ThemeData().copyWith(primaryColor: Colors.blue),
                darkTheme:
                    ThemeData.dark().copyWith(primaryColor: Colors.amber),
                themeMode: settingsController.themeMode,
              );
            }),
      ),
    );
  }
}
