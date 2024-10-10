// ignore_for_file: depend_on_referenced_packages
import 'package:ai_image_annotator/extensions/string_extensions.dart';
import 'package:ai_image_annotator/models/coco_model/coco_encoders.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coco_image.g.dart';

const cocoImageNamePattern = '000000000000';

@JsonSerializable(explicitToJson: true)
class CocoImage {
  CocoImage({
    this.id,
    this.license,
    this.fileName,
    this.width,
    this.height,
    this.dateCaptured,
    this.flickerUrl,
    this.cocoUrl,
  });

  int? id;
  int? license;
  @JsonKey(name: 'file_name')
  String? fileName;
  @JsonKey(name: 'coco_url')
  String? cocoUrl;
  @JsonKey(name: 'flickr_url')
  String? flickerUrl;
  int? width;
  int? height;

  String idToImageName(int imageId) {
    final match = RegExp(r'[\d]{5,}').firstMatch(fileName!);
    // COCO_val2014_000000309022
    if (match != null) {
      final pattern = fileName!.substring(match.start, match.end);
      final paddedId = pattern.padIntWithPattern(imageId);
      final newFileName = '${fileName!.substring(0, match.start)}$paddedId.jpg';
      return newFileName;
    }

    /// this should never happen in reality
    return '${cocoImageNamePattern.padIntWithPattern(imageId)}.jpg';
  }

  @JsonKey(name: 'date_captured', toJson: encodeCocoDate)
  DateTime? dateCaptured;

  @override
  bool operator ==(covariant CocoImage other) {
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

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
