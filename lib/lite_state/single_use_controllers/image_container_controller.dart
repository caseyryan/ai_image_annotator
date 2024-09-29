import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lite_state/lite_state.dart';

enum WorkMode {
  addPoint,
  movePoint,
}

class ImageContainerController extends LiteStateController<ImageContainerController> {
  TransformationController? _transformationController;
  TransformationController get transformationController {
    if (_transformationController == null) {
      _transformationController = TransformationController();
      _transformationController!.addListener(_onTransformationUpdate);
    }
    return _transformationController!;
  }

  Color get shapeColor {
    return Colors.blue;
  }

  double get margin {
    return 100.0;
  }

  void clearPoints() {
    _pointVectors.clear();
    _activeVectorIndex = 0;
    rebuild();
  }

  WorkMode _workMode = WorkMode.addPoint;

  double get scale {
    return transformationController.value.getMaxScaleOnAxis();
  }

  double get translationX {
    return transformationController.value.getTranslation().x;
  }

  double get translationY {
    return transformationController.value.getTranslation().y;
  }

  final List<List<Offset>> _pointVectors = [[]];

  List<List<Offset>> get pointVectors => _pointVectors;

  Offset? _pendingPoint;

  int _activeVectorIndex = 0;

  void _onTransformationUpdate() {
    rebuild();
  }

  List<Offset> get _activeVector {
    if (_pointVectors.isEmpty) {
      _pointVectors.add([]);
    }
    if (_activeVectorIndex >= _pointVectors.length) {
      _activeVectorIndex = _pointVectors.length - 1;
    }
    return _pointVectors[_activeVectorIndex];
  }

  void onPointerDown(PointerDownEvent event) {
    if (_workMode == WorkMode.addPoint) {
      if (event.buttons != kSecondaryButton) {
        _pendingPoint = event.localPosition;
      }
    }
  }

  void onPointerUp(PointerUpEvent event) {
    final Offset localPosition = event.localPosition;
    if (_workMode == WorkMode.addPoint) {
      if (_pendingPoint != null && (localPosition - _pendingPoint!).distance <= 10) {
        _activeVector.add(
          _pendingPoint!,
        );
        _pendingPoint = null;
        rebuild();
      }
    }
  }

  void onPointerCancel(PointerCancelEvent event) {
    _pendingPoint = null;
    rebuild();
  }

  @override
  void reset() {}
  @override
  void onLocalStorageInitialized() {}
}
