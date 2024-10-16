import 'dart:convert';
import 'dart:io';

import 'package:ai_image_annotator/extensions/file_pick_result_extension.dart';
import 'package:ai_image_annotator/extensions/string_extensions.dart';
import 'package:ai_image_annotator/models/coco_model/coco_annotation.dart';
import 'package:ai_image_annotator/models/coco_model/coco_category.dart';
import 'package:ai_image_annotator/models/coco_model/coco_image.dart';
import 'package:ai_image_annotator/utils/system_alerts.dart';

/// This API might look strange because of using
/// dynamic search params. It was made intentionally to
/// resemble the python COCO API
class Coco {
  final Map _annotationJson;
  Coco._({
    required Map<dynamic, dynamic> annotationJson,
  }) : _annotationJson = annotationJson {
    final imageIds = getImageIds();
    if (imageIds.isNotEmpty) {
      imageIds.sort();
      _lastImage = getImages(
        imageId: imageIds.last,
      ).firstOrNull;
    }
    final annotationIds = getAnnotationIds();
    if (annotationIds.isNotEmpty) {
      annotationIds.sort();
      _lastAnnotationId = annotationIds.last;
    }
  }

  int _lastAnnotationId = 0;

  CocoImage? _lastImage;

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

  Future<CocoImage?> isFileInDataset(File value) async {
    final fileName = value.name;
    final imageInDataset = getImages(imageName: fileName);
    if (imageInDataset.isNotEmpty) {
      return imageInDataset.first;
    }
    return null;
  }

  Future<CocoImage?> addNewImage({
    required File imageFile,
    required Directory imageDirectory,
  }) async {
    if (_lastImage != null) {
      final newImageId = _lastImage!.id! + 1;
      final dimensions = await imageFile.getImageDimensions();
      if (dimensions != null) {
        /// we need to copy the image to our dataset and encode it to jpg
        final newFileName = _lastImage!.idToImageName(newImageId);
        final success = await imageFile.encodeImageToJpgResizeAndSave(
          outputPath: imageDirectory.combinePath(newFileName),
          quality: 100,
        );
        if (success) {
          final image = CocoImage(
            id: newImageId,
            license: 3,
            fileName: newFileName,
            dateCaptured: DateTime.now(),
            cocoUrl: '',
            width: dimensions.width,
            height: dimensions.height,
            flickerUrl: '',
          );
          _lastImage = image;
          final imageJson = image.toJson();
          _annotationJson['images'] ??= [];
          (_annotationJson['images'] as List).add(imageJson);
          return image;
        } else {
          showAlert(
            header: 'Error'.translate(),
            text: '${'Could not save image in:'.translate()} ${imageDirectory.path}',
          );
        }
      } else {
        showAlert(
          header: 'Error'.translate(),
          text: 'Cannot read image dimensions'.translate(),
        );
      }
    }
    return null;
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

  Future<bool> saveAsJson({
    required File jsonFile,
  }) async {
    if (jsonFile.existsSync()) {
      await jsonFile.writeAsString(
        jsonEncode(_annotationJson),
        flush: true,
      );
      return true;
    }
    return false;
  }

  List<int> getImageIds() {
    final list = _annotationJson['images'] as List;
    return list.map((e) => e['id']).cast<int>().toList();
  }

  List<int> getAnnotationIds() {
    final list = _annotationJson['annotations'] as List;
    return list.map((e) => e['id']).cast<int>().toList();
  }

  List<CocoImage> getImages({
    Object? imageId,
    Object? imageName,
  }) {
    final all = [imageId, imageName];
    assert(
      all.where((e) => e != null).length == 1,
      'Either imageId or imageName must be provided',
    );
    final searchId = imageId ?? imageName;
    String keyName = 'id';
    if (imageName != null) {
      keyName = 'file_name';
    }
    List result = _annotationJson['images'] as List;
    if (searchId is int) {
      final list = result;
      result = list.where((e) => e[keyName] == searchId).toList();
    } else if (searchId is String) {
      final list = result;
      result = list.where((e) => e[keyName] == searchId).toList();
    } else if (searchId is List) {
      final list = result;
      result = list.where((e) => searchId.contains(e[keyName])).toList();
    }
    return result.map((e) => CocoImage.fromJson(e)).toList();
  }

  CocoImage? getFirstImage() {
    final map = (_annotationJson['images'] as List).firstOrNull as Map?;
    return map != null ? CocoImage.fromJson(map.cast<String, dynamic>()) : null;
  }

  List<CocoCategory>? _cocoCategories;

  List<CocoCategory> getCategories() {
    if (_cocoCategories != null) {
      return _cocoCategories!;
    }
    final list = _annotationJson['categories'] as List;
    _cocoCategories = list.map((e) => CocoCategory.fromJson(e)).toList();
    return _cocoCategories!;
  }

  List<String> getCategoryNames() {
    return getCategories().map((e) => e.name).cast<String>().toList();
  }

  List<CocoAnnotation> getAnnotations({
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

    List result = (_annotationJson['annotations'] as List?) ?? [];
    if (searchId is int) {
      result = result.where((e) => e[keyName] == searchId).toList();
    } else if (searchId is String) {
      final list = _annotationJson['annotations'] as List;
      result = list.where((e) => e[keyName] == int.parse(searchId)).toList();
    } else if (searchId is List) {
      final list = _annotationJson['annotations'] as List;
      result = list.where((e) => searchId.contains(e[keyName])).toList();
    } else if (searchId == null) {
      final list = _annotationJson['annotations'] as List;
      result = list;
    }

    return result.map((e) => CocoAnnotation.fromJson(e)).toList();
  }
}
