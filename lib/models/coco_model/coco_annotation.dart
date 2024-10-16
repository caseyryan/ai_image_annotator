// ignore_for_file: depend_on_referenced_packages
import 'dart:ui';

import 'package:ai_image_annotator/extensions/string_extensions.dart';
import 'package:ai_image_annotator/lite_state/long_living_controllers/coco_image_annotator_controller.dart';
import 'package:ai_image_annotator/models/coco_model/coco_category.dart';
import 'package:ai_image_annotator/utils/segmentation_utils.dart';
import 'package:ai_image_annotator/widgets/snack_bar_overlay.dart';
import 'package:flutter/material.dart' as material;
import 'package:json_annotation/json_annotation.dart';

part 'coco_annotation.g.dart';

@JsonSerializable(explicitToJson: true)
class CocoAnnotation {
  CocoAnnotation({
    this.id,
    this.imageId,
    this.categoryId,
    this.bbox,
    this.area,
    this.iscrowd,
    this.segmentation,
  });

  int? id;
  @JsonKey(name: 'image_id')
  int? imageId;
  @JsonKey(name: 'category_id')
  int? categoryId;
  @JsonKey(fromJson: _processSegmentation)
  List<List<double>>? segmentation;
  List<double>? bbox;
  double? area;
  int? iscrowd;

  CocoCategory? get category {
    if (categoryId == null) {
      return null;
    }
    /// this must always be dynamic since the categoryId can be changed by a user
    return cocoImageAnnotatorController.getCocoCategoryById(categoryId);
  }

  Color get color {
    return category?.color ?? material.Colors.blue;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isValid {
    return segmentation?.isNotEmpty == true && area != null;
  }

  List<List<Offset>>? _pointVectors;

  int _activeVectorIndex = 0;

  List<List<Offset>> get pointVectors {
    if (_pointVectors != null) {
      return _pointVectors!;
    }
    if (segmentation?.isNotEmpty != true) {
      segmentation = [[]];
    }
    _pointVectors = [[]];
    for (var i = 0; i < segmentation!.length; i++) {
      final list = segmentation![i];
      for (var j = 0; j < list.length; j += 2) {
        if (_pointVectors!.length <= i) {
          _pointVectors!.add([]);
        }
        _pointVectors![i].add(
          Offset(
            list[j].toDouble(),
            list[j + 1].toDouble(),
          ),
        );
      }
    }
    return _pointVectors!;
  }

  void clearPoints() {
    _pointVectors = null;
    _activeVectorIndex = 0;
  }

  List<Offset> get activeVector {
    if (_activeVectorIndex >= pointVectors.length && _activeVectorIndex > 0) {
      _activeVectorIndex = pointVectors.length - 1;
    }
    return pointVectors[_activeVectorIndex];
  }

  void addNewShape() {
    if (pointVectors.isEmpty) {
      pointVectors.add([]);
    } else {
      if (pointVectors.last.isNotEmpty) {
        pointVectors.add([]);
      } else {
        showInformation(
          title: 'Oops!'.translate(),
          text: 'An empty shape already already exists for this object. Just draw it'.translate(),
        );
      }
    }
    _activeVectorIndex++;
  }

  static CocoAnnotation deserialize(Map<String, dynamic> json) {
    return CocoAnnotation.fromJson(json);
  }

  factory CocoAnnotation.fromJson(Map<String, dynamic> json) {
    return _$CocoAnnotationFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CocoAnnotationToJson(this);
  }
}

List<List<double>>? _processSegmentation(data) {
  if (data is List && data.every((e) => e is List)) {
    final newData = data.map((e) => e.cast<double>()).toList();
    return newData.cast<List<double>>();
  } else if (data is Map) {
    if (data.containsKey('counts')) {
      return rleToContours(data);
    }
  }
  return null;
}
