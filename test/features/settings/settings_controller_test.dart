import 'package:cake_it_app/src/features/settings/data/settings_controller.dart';
import 'package:cake_it_app/src/features/settings/data/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsService extends Mock implements SettingsService {}

void main() {
  setUpAll(() {
    registerFallbackValue(ThemeMode.system);
  });

  late MockSettingsService service;
  late SettingsController controller;

  setUp(() {
    service = MockSettingsService();
    controller = SettingsController(service);
  });

  group('SettingsController', () {
    group('loadSettings', () {
      test('reads themeMode from service and notifies listeners', () async {
        when(() => service.themeMode()).thenAnswer((_) async => ThemeMode.dark);

        var notified = false;
        controller.addListener(() => notified = true);

        await controller.loadSettings();

        expect(controller.themeMode, ThemeMode.dark);
        expect(notified, isTrue);
      });

      test('defaults to ThemeMode.system when service returns system',
          () async {
        when(() => service.themeMode())
            .thenAnswer((_) async => ThemeMode.system);

        await controller.loadSettings();

        expect(controller.themeMode, ThemeMode.system);
      });
    });

    group('updateThemeMode', () {
      setUp(() async {
        when(() => service.themeMode())
            .thenAnswer((_) async => ThemeMode.system);
        when(() => service.updateThemeMode(any())).thenAnswer((_) async {});
        await controller.loadSettings();
      });

      test('updates themeMode and notifies listeners', () async {
        var notified = false;
        controller.addListener(() => notified = true);

        await controller.updateThemeMode(ThemeMode.dark);

        expect(controller.themeMode, ThemeMode.dark);
        expect(notified, isTrue);
        verify(() => service.updateThemeMode(ThemeMode.dark)).called(1);
      });

      test('does nothing when null is passed', () async {
        var notified = false;
        controller.addListener(() => notified = true);

        await controller.updateThemeMode(null);

        expect(notified, isFalse);
        verifyNever(() => service.updateThemeMode(any()));
      });

      test('does nothing when the same themeMode is passed', () async {
        // Start on system (set in setUp)
        var notified = false;
        controller.addListener(() => notified = true);

        await controller.updateThemeMode(ThemeMode.system);

        expect(notified, isFalse);
        verifyNever(() => service.updateThemeMode(any()));
      });

      test('persists the new theme via the service', () async {
        await controller.updateThemeMode(ThemeMode.light);

        verify(() => service.updateThemeMode(ThemeMode.light)).called(1);
      });
    });
  });
}
