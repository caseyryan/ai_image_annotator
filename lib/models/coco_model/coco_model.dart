// ignore_for_file: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'coco_annotation.dart';
import 'coco_category.dart';
import 'coco_image.dart';

part 'coco_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CocoModel {
  CocoModel({
    this.images,
    this.annotations,
    this.categories,
  });

  int? _selectedImageId;
  int get selectedImageId => _selectedImageId ?? images?.firstOrNull?.id ?? 0;

  CocoImage? get selectedImage => images!.firstWhereOrNull((e) => e.id == selectedImageId);

  /// This is the same as selected object index
  int _selectedAnnotationIndex = 0;

  CocoAnnotation? _activeAnnotation;

  CocoAnnotation? get activeAnnotation {
    final allAnnotations = annotations?.where((e) => e.imageId == selectedImageId);
    if (allAnnotations?.isNotEmpty != true) {
      _selectedAnnotationIndex = 0;
      _activeAnnotation = CocoAnnotation(
        imageId: selectedImageId,
        bbox: [0, 0, 0, 0],
      );
      annotations?.add(_activeAnnotation!);
    }
    return _activeAnnotation;
  }

  List<CocoImage>? images;
  List<CocoAnnotation>? annotations;
  List<CocoCategory>? categories;

  static CocoModel deserialize(Map<String, dynamic> json) {
    return CocoModel.fromJson(json);
  }

  factory CocoModel.fromJson(Map<String, dynamic> json) {
      return _$CocoModelFromJson(json);
    }
  
  Map<String, dynamic> toJson() {
    return _$CocoModelToJson(this);
  }
}
