// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coco_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CocoImage _$CocoImageFromJson(Map<String, dynamic> json) => CocoImage(
      id: (json['id'] as num?)?.toInt(),
      fileName: json['file_name'] as String?,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CocoImageToJson(CocoImage instance) => <String, dynamic>{
      'id': instance.id,
      'file_name': instance.fileName,
      'width': instance.width,
      'height': instance.height,
    };
