import 'package:cake_it_app/src/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'src/app.dart';
import 'src/features/settings/data/settings_controller.dart';
import 'src/features/settings/data/settings_service.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  GoRouter router = createRouter(settingsController);

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController, router: router));
}
