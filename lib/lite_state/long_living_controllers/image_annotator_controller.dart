import 'package:ai_image_annotator/models/coco_model/coco_model.dart';
import 'package:lite_state/lite_state.dart';

ImageAnnotatorController get imageAnnotatorController {
  return findController<ImageAnnotatorController>();
}

class ImageAnnotatorController extends LiteStateController<ImageAnnotatorController> {


  CocoModel? _openedCocoModel;
  
  @override
  void reset() {
    
  }
  @override
  void onLocalStorageInitialized() {
    
  }
}