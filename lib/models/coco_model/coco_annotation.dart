// ignore_for_file: depend_on_referenced_packages
import 'dart:ui';

import 'package:ai_image_annotator/extensions/string_extensions.dart';
import 'package:ai_image_annotator/widgets/snack_bar_overlay.dart';
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
  // TODO: Implement RLE binary masks as well
  List<List<double>>? segmentation;
  List<double>? bbox;
  double? area;
  int? iscrowd;

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
