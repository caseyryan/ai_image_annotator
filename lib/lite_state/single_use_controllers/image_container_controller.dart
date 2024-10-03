import 'package:ai_image_annotator/models/coco_model/coco_annotation.dart';
import 'package:ai_image_annotator/models/coco_model/coco_category.dart';
import 'package:ai_image_annotator/models/coco_model/coco_image.dart';
import 'package:ai_image_annotator/models/coco_model/coco_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lite_state/lite_state.dart';

enum WorkMode {
  addPoint,
  movePoint,
}

enum AdditionType {
  shape,
  object,
  category;

  Color get color {
    switch (this) {
      case AdditionType.shape:
        return Colors.blue;
      case AdditionType.object:
        return Colors.red;
      case AdditionType.category:
        return Colors.green;
    }
  }
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

  void onAddNew(AdditionType type) {
    if (type == AdditionType.shape) {
      _annotation?.addNewShape();
      rebuild();
    } else if (type == AdditionType.object) {}
  }

  double get margin {
    return 100.0;
  }

  void clearPoints() {
    _annotation?.clearPoints();
    rebuild();
  }

  CocoAnnotation? get _annotation {
    return _cocoModel.activeAnnotation;
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

  final CocoModel _cocoModel = CocoModel(
    annotations: [],
    images: [
      CocoImage(
        fileName: 'City',
        id: 0,
        width: 564,
        height: 705,
      ),
    ],
    categories: [
      CocoCategory(id: 0, name: 'Car'),
      CocoCategory(id: 1, name: 'Woman'),
    ],
  );

  List<List<Offset>> get pointVectors => _cocoModel.activeAnnotation?.pointVectors ?? [];

  Offset? _pendingPoint;

  void _onTransformationUpdate() {
    rebuild();
  }

  List<Offset> get _activeVector {
    return _annotation?.activeVector ?? [];
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
