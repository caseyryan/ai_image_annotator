import 'package:ai_image_annotator/lite_state/long_living_controllers/coco_image_annotator_controller.dart';
import 'package:ai_image_annotator/models/coco_model/coco_annotation.dart';
import 'package:ai_image_annotator/models/coco_model/coco_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lite_state/lite_state.dart';

enum ButtonType {
  shape,
  object,
  category,
  settings,
  draw,
  drag,
}

class VectorWrapper {
  List<List<Offset>> points;
  CocoAnnotation? annotation;
  VectorWrapper({
    required this.points,
    required this.annotation,
  });
}

class ImageContainerController extends LiteStateController<ImageContainerController> {
  Offset _rightOffset = Offset.zero;
  Offset get rightOffset => _rightOffset;
  List<CocoAnnotation>? _annotations;
  List<CocoAnnotation> get annotations {
    _annotations ??= cocoImageAnnotatorController.annotations;
    return _annotations!;
  }

  int _activeAnnotationIndex = 0;
  int get activeAnnotationIndex {
    if (_activeAnnotationIndex >= annotations.length) {
      _activeAnnotationIndex = annotations.length - 1;
    }
    return _activeAnnotationIndex;
  }

  CocoImage get image {
    return cocoImageAnnotatorController.selectedImage!;
  }

  CocoAnnotation? get activeAnnotation {
    if (annotations.isEmpty) {
      return null;
    }
    return annotations[_activeAnnotationIndex];
  }

  TransformationController? _transformationController;
  TransformationController get transformationController {
    if (_transformationController == null) {
      _transformationController = TransformationController();
      _transformationController!.addListener(_onTransformationUpdate);
    }
    return _transformationController!;
  }

  void updatePanelPosition(Offset offset) {
    _rightOffset += offset;
    rebuild();
  }

  void onAddNew(ButtonType type) {
    if (type == ButtonType.shape) {
      _annotation?.addNewShape();
      rebuild();
    } else if (type == ButtonType.object) {}
  }

  double get margin {
    return 100.0;
  }

  void clearPoints() {
    _annotation?.clearPoints();
    rebuild();
  }

  CocoAnnotation? get _annotation {
    return activeAnnotation;
  }

  ButtonType _workMode = ButtonType.draw;
  ButtonType get workMode => _workMode;

  void updateWorkMode(ButtonType value) {
    _workMode = value;
    rebuild();
  }

  double get scale {
    return transformationController.value.getMaxScaleOnAxis();
  }

  double get translationX {
    return transformationController.value.getTranslation().x;
  }

  double get translationY {
    return transformationController.value.getTranslation().y;
  }
  VectorWrapper? _activeVectors;
  VectorWrapper get activeVectors {
    _activeVectors ??= VectorWrapper(
        points: activeAnnotation?.pointVectors ?? [],
        annotation: activeAnnotation,
      );
    return _activeVectors!;
  }

  List<VectorWrapper>? _inactiveVectors;
  List<VectorWrapper> get inactiveVectors {
    if (_inactiveVectors != null) {
      return _inactiveVectors!;
    }
    if (annotations.isNotEmpty) {
      _inactiveVectors = annotations.where((e) => e != activeAnnotation).map((e) {
        return VectorWrapper(
          points: e.pointVectors,
          annotation: e,
        );
      }).toList();
    }
    return [];
  }

  Offset? _pendingPoint;

  void _onTransformationUpdate() {
    rebuild();
  }

  List<Offset> get _activeVector {
    return _annotation?.activeVector ?? [];
  }

  void onPointerDown(PointerDownEvent event) {
    if (_workMode == ButtonType.draw) {
      if (event.buttons != kSecondaryButton) {
        _pendingPoint = event.localPosition;
      }
    }
  }

  void onPointerUp(PointerUpEvent event) {
    final Offset localPosition = event.localPosition;
    if (_workMode == ButtonType.draw) {
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
