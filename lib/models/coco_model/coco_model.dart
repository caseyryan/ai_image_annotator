// ignore_for_file: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'coco_annotation.dart';
import 'coco_category.dart';
import 'coco_image.dart';

part 'coco_model.g.dart';

// {
//     "info": {
//         "description": "COCO 2017 Dataset","url": "http://cocodataset.org","version": "1.0","year": 2017,"contributor": "COCO Consortium","date_created": "2017/09/01"
//     },
//     "licenses": [
//         {"url": "http://creativecommons.org/licenses/by/2.0/","id": 4,"name": "Attribution License"}
//     ],
//     "images": [
//         {"id": 242287, "license": 4, "coco_url": "http://images.cocodataset.org/val2017/xxxxxxxxxxxx.jpg", "flickr_url": "http://farm3.staticflickr.com/2626/xxxxxxxxxxxx.jpg", "width": 426, "height": 640, "file_name": "xxxxxxxxx.jpg", "date_captured": "2013-11-15 02:41:42"},
//         {"id": 245915, "license": 4, "coco_url": "http://images.cocodataset.org/val2017/nnnnnnnnnnnn.jpg", "flickr_url": "http://farm1.staticflickr.com/88/xxxxxxxxxxxx.jpg", "width": 640, "height": 480, "file_name": "nnnnnnnnnn.jpg", "date_captured": "2013-11-18 02:53:27"}
//     ],
//     "annotations": [
//         {"id": 125686, "category_id": 0, "iscrowd": 0, "segmentation": [[164.81, 417.51,......167.55, 410.64]], "image_id": 242287, "area": 42061.80340000001, "bbox": [19.23, 383.18, 314.5, 244.46]},
//         {"id": 1409619, "category_id": 0, "iscrowd": 0, "segmentation": [[376.81, 238.8,........382.74, 241.17]], "image_id": 245915, "area": 3556.2197000000015, "bbox": [399, 251, 155, 101]},
//         {"id": 1410165, "category_id": 1, "iscrowd": 0, "segmentation": [[486.34, 239.01,..........495.95, 244.39]], "image_id": 245915, "area": 1775.8932499999994, "bbox": [86, 65, 220, 334]}
//     ],
//     "categories": [
//         {"supercategory": "speaker","id": 0,"name": "echo"},
//         {"supercategory": "speaker","id": 1,"name": "echo dot"}
//     ]
// }

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
