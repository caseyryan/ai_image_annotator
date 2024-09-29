part of '../main.dart';


void _initLiteStateControllers() {
  initControllersLazy({
    ImageAnnotatorController: () => ImageAnnotatorController(),
    SettingsController: () => SettingsController(),
    ThemeController: () => ThemeController(),
  });
}
