part of 'main.dart';

void _initLiteStateControllers() {
  initControllersLazy({
    ImageAnnotatorController: () => ImageAnnotatorController()
  });
}
