// ignore_for_file: depend_on_referenced_packages
import 'dart:ui';

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
  List<List<int>>? segmentation;
  List<int>? bbox;
  int? area;
  int? iscrowd;

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
    pointVectors.add([]);
    _activeVectorIndex ++;
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
