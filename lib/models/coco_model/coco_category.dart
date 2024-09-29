// ignore_for_file: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

part 'coco_category.g.dart';

@JsonSerializable(explicitToJson: true)
class CocoCategory {
  const CocoCategory({
    this.name = '',
    this.id = 0,
  });

  final int id;
  final String name;

  static CocoCategory deserialize(Map<String, dynamic> json) {
    return CocoCategory.fromJson(json);
  }

  factory CocoCategory.fromJson(Map<String, dynamic> json) {
      return _$CocoCategoryFromJson(json);
    }
  
  Map<String, dynamic> toJson() {
    return _$CocoCategoryToJson(this);
  }
}


