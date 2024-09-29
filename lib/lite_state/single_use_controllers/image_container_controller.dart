import 'package:flutter/material.dart';
import 'package:lite_state/lite_state.dart';

class ImageContainerController extends LiteStateController<ImageContainerController> {
  final TransformationController _transformationController = TransformationController();
  TransformationController get trackingScrollController => _transformationController;

  @override
  void reset() {}
  @override
  void onLocalStorageInitialized() {}
}
