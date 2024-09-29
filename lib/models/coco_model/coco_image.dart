// ignore_for_file: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'coco_image.g.dart';

/// {"id": 245915, "license": 4, "coco_url": "http://images.cocodataset.org/val2017/nnnnnnnnnnnn.jpg", "flickr_url": "http://farm1.staticflickr.com/88/xxxxxxxxxxxx.jpg", "width": 640, "height": 480, "file_name": "nnnnnnnnnn.jpg", "date_captured": "2013-11-18 02:53:27"}
@JsonSerializable(explicitToJson: true)
class CocoImage {
  CocoImage({
    this.id,
    this.fileName,
    this.width,
    this.height,
  });

  int? id;
  @JsonKey(name: 'file_name')
  String? fileName;
  int? width;
  int? height;

  static CocoImage deserialize(Map<String, dynamic> json) {
    return CocoImage.fromJson(json);
  }

  factory CocoImage.fromJson(Map<String, dynamic> json) {
      return _$CocoImageFromJson(json);
    }
  
  Map<String, dynamic> toJson() {
    return _$CocoImageToJson(this);
  }
}
