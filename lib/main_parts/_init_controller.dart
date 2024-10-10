part of '../main.dart';


void _initLiteStateControllers() {
  initControllersLazy({
    CocoImageAnnotatorController: () => CocoImageAnnotatorController(),
    SettingsController: () => SettingsController(),
    ThemeController: () => ThemeController(),
  });
}
