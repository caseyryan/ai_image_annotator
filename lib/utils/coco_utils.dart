import 'dart:convert';

class Coco {
  final Map _annotationJson;
  Coco._({
    required Map<dynamic, dynamic> annotationJson,
  }) : _annotationJson = annotationJson;

  factory Coco.fromString(String json) {
    if (json.startsWith('{')) {
      try {
        var data = jsonDecode(json);
        // if (kDebugMode) {
        //   data = {
        //     'info': data['info'],
        //     'images': data['images'].take(10).toList(),
        //     'annotations': data['annotations'].take(10).toList(),
        //     'categories': data['categories'],
        //     'licenses': data['licenses'],
        //   };
        //   print((data as Map).toFormattedJson());
        // }
        return Coco._(
          annotationJson: data,
        );
      } catch (_) {}
    }
    return Coco.empty();
  }

  factory Coco.empty() {
    return Coco._(
      annotationJson: {
        'info': {},
        'images': [],
        'annotations': [],
        'categories': [],
        'licenses': [],
      },
    );
  }

  List<dynamic> getImageIds() {
    final list = _annotationJson['images'] as List;
    return list.map((e) => e['id']).toList();
  }

  List getCategories() {
    return _annotationJson['categories'] as List;
  }

  List<String> getCategoryNames() {
    return getCategories().map((e) => e['name']).cast<String>().toList();
  }

  List<dynamic> getAnnotations({
    Object? imageId,
    Object? categoryId,
  }) {
    final params = [
      imageId,
      categoryId,
    ];
    assert(
      params.where((e) => e != null).length == 1,
      'Either imageId or categoryId must be provided',
    );
    final searchId = imageId ?? categoryId;
    String keyName = 'image_id';
    if (categoryId != null) {
      keyName = 'category_id';
    }

    if (searchId is int) {
      final list = _annotationJson['annotations'] as List;
      return list.where((e) => e[keyName] == searchId).toList();
    } else if (searchId is String) {
      final list = _annotationJson['annotations'] as List;
      return list.where((e) => e[keyName] == int.parse(searchId)).toList();
    } else if (searchId is List) {
      final list = _annotationJson['annotations'] as List;
      return list.where((e) => searchId.contains(e[keyName])).toList();
    } else if (searchId == null) {
      final list = _annotationJson['annotations'] as List;
      return list;
    }

    return [];
  }
}
