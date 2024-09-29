import 'package:lite_state/lite_state.dart';

ImageAnnotatorController get imageAnnotatorController {
  return findController<ImageAnnotatorController>();
}

class ImageAnnotatorController extends LiteStateController<ImageAnnotatorController> {
  
  @override
  void reset() {
    
  }
  @override
  void onLocalStorageInitialized() {
    
  }
}