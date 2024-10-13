// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coco_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CocoImage _$CocoImageFromJson(Map<String, dynamic> json) => CocoImage(
      id: (json['id'] as num?)?.toInt(),
      license: (json['license'] as num?)?.toInt(),
      fileName: json['file_name'] as String?,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      dateCaptured: json['date_captured'] == null
          ? null
          : DateTime.parse(json['date_captured'] as String),
      flickerUrl: json['flickr_url'] as String?,
      cocoUrl: json['coco_url'] as String?,
    );

Map<String, dynamic> _$CocoImageToJson(CocoImage instance) => <String, dynamic>{
      'id': instance.id,
      'license': instance.license,
      'file_name': instance.fileName,
      'coco_url': instance.cocoUrl,
      'flickr_url': instance.flickerUrl,
      'width': instance.width,
      'height': instance.height,
      'date_captured': encodeCocoDate(instance.dateCaptured),
    };
