import 'package:lite_state/lite_state.dart';

SettingsController get settingsController {
  return findController<SettingsController>();
}

class SettingsController extends LiteStateController<SettingsController> {



  Future updateFontScale(int toggleIndex) async {
    setPersistentValue('fontScaleToggleIndex', toggleIndex);
  }

  double getFontScaleForIndex(int index) {
    switch (index) {
      case 0:
        return 1.0;
      case 1:
        return 1.2;
      case 2:
        return 1.4;
    }
    return 1.0;
  }

  double get fontScale {
    return getFontScaleForIndex(fontScaleToggleIndex);
  }

  int get fontScaleToggleIndex {
    return getPersistentValue<int>('fontScaleToggleIndex') ?? 0;
  }

  @override
  void reset() {}
  @override
  void onLocalStorageInitialized() {}
}
