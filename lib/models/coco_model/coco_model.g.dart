// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coco_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CocoModel _$CocoModelFromJson(Map<String, dynamic> json) => CocoModel(
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => CocoImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      annotations: (json['annotations'] as List<dynamic>?)
          ?.map((e) => CocoAnnotation.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => CocoCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CocoModelToJson(CocoModel instance) => <String, dynamic>{
      'images': instance.images?.map((e) => e.toJson()).toList(),
      'annotations': instance.annotations?.map((e) => e.toJson()).toList(),
      'categories': instance.categories?.map((e) => e.toJson()).toList(),
    };
