// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coco_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CocoCategory _$CocoCategoryFromJson(Map<String, dynamic> json) => CocoCategory(
      name: json['name'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CocoCategoryToJson(CocoCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
