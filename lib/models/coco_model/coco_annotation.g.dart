// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coco_annotation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CocoAnnotation _$CocoAnnotationFromJson(Map<String, dynamic> json) =>
    CocoAnnotation(
      id: (json['id'] as num?)?.toInt(),
      imageId: (json['image_id'] as num?)?.toInt(),
      categoryId: (json['category_id'] as num?)?.toInt(),
      bbox: (json['bbox'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      area: (json['area'] as num?)?.toDouble(),
      iscrowd: (json['iscrowd'] as num?)?.toInt(),
      segmentation: _processSegmentation(json['segmentation']),
    );

Map<String, dynamic> _$CocoAnnotationToJson(CocoAnnotation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image_id': instance.imageId,
      'category_id': instance.categoryId,
      'segmentation': instance.segmentation,
      'bbox': instance.bbox,
      'area': instance.area,
      'iscrowd': instance.iscrowd,
    };
