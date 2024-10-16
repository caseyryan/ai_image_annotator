import 'dart:io';

import 'package:ai_image_annotator/extensions/file_pick_result_extension.dart';
import 'package:ai_image_annotator/extensions/string_extensions.dart';
import 'package:ai_image_annotator/models/coco_model/coco_annotation.dart';
import 'package:ai_image_annotator/models/coco_model/coco_category.dart';
import 'package:ai_image_annotator/models/coco_model/coco_image.dart';
import 'package:ai_image_annotator/models/coco_model/coco_model.dart';
import 'package:ai_image_annotator/utils/coco_utils.dart';
import 'package:ai_image_annotator/utils/platform_dialogs.dart';
import 'package:ai_image_annotator/utils/system_alerts.dart';
import 'package:collection/collection.dart';
import 'package:flutter/rendering.dart';
import 'package:lite_forms/lite_forms.dart';
// import 'package:flutter_platform_alert/flutter_platform_alert.dart';

CocoImageAnnotatorController get cocoImageAnnotatorController {
  return findController<CocoImageAnnotatorController>();
}

class CocoImageAnnotatorController extends LiteStateController<CocoImageAnnotatorController> {
  CocoImageAnnotatorController() : super(preserveLocalStorageOnControllerDispose: true);

  Coco? _coco;

  CocoImage? _selectedImage;
  CocoImage? get selectedImage => _selectedImage;
  List<CocoAnnotation> get annotations {
    List<CocoAnnotation> currentAnnotations = [];
    if (selectedImage != null && isDataSetSelected) {
      currentAnnotations = _coco!.getAnnotations(
        imageId: selectedImage!.id,
      );
    }
    if (currentAnnotations.isEmpty) {
      currentAnnotations.add(
        CocoAnnotation(
          imageId: selectedImage!.id,
          area: 0.0,
          bbox: [0.0, 0.0, 0.0, 0.0],
          categoryId: null,
          // id:
        ),
      );
    }

    return currentAnnotations;
  }

  bool get hasSelectedImage {
    return selectedImage != null;
  }

  List<CocoCategory> get categories => _coco?.getCategories() ?? [];


  CocoCategory? getCocoCategoryById(int? id) {
    if (id == null) {
      return null;
    }
    return categories.firstWhereOrNull((e) => e.id == id);
  }

  File? get selectedImageAsFile {
    if (!hasSelectedImage || _coco == null || selectedImageDirectory?.existsSync() != true) {
      return null;
    }
    return File(
      selectedImageDirectory!.combinePath(selectedImage!.fileName!),
    );
  }

  bool get isDataSetSelected {
    return _coco != null;
  }

  String get pageTitle {
    if (hasAnnotationFile) {
      return selectedAnnotationFile!.name;
    }
    return 'COCO Annotator'.translate();
  }

  Directory? get selectedImageDirectory {
    final path = getPersistentValue<String>('selectedImageDirectory');
    if (path?.isNotEmpty == true) {
      final dir = Directory(path);
      if (dir.existsSync()) {
        return dir;
      } else {
        setPersistentValue('selectedImageDirectory', null);
      }
    }
    return null;
  }

  Future pickAnnotationJsonFile() async {
    final result = await FilePicker.platform.pickFiles(
      initialDirectory: selectedAnnotationFile?.parent.path,
      type: FileType.custom,
      dialogTitle: 'Select Annotation JSON File'.translate(),
      allowMultiple: false,
      allowedExtensions: [
        'json',
        'JSON',
      ],
    );
    if (result?.files.isNotEmpty == true) {
      final file = File(result!.files.first.path!);
      selectedAnnotationFile = file;
      tryLoadData();
    }
  }

  Future selectImageToEdit() async {
    startLoading();
    final result = await FilePicker.platform.pickFiles(
      initialDirectory: selectedImageDirectory!.path,
      type: FileType.image,
      dialogTitle: 'Select Image From Dataset'.translate(),
      allowMultiple: false,
    );
    if (result != null) {
      final imageFile = result.toFile();
      final selectedCocoImage = await _coco!.isFileInDataset(imageFile);
      if (selectedCocoImage != null) {
        debugPrint('Was present in the dataset');

        /// was in dataset
        _updateCocoImage(selectedCocoImage);
      } else {
        debugPrint('Was not in dataset');
        final confirmed = await showConfirmation(
          header: 'Confirmation required'.translate(),
          text: 'This image is not yet in your dataset. Would you like to add it?'.translate(),
        );
        if (confirmed) {
          await _saveImageToDataset(imageFile);
        }
      }
    }
    stopLoading();
  }

  void _updateCocoImage(CocoImage? value) {
    if (value != null) {
      _selectedImage = value;
      rebuild();
    }
  }

  Future addImageToDataset() async {
    if (isLoading) {
      return;
    }
    await _checkCocoInitialized();
    if (hasImageDirectory) {
      startLoading();
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        dialogTitle: 'Select an Image File'.translate(),
        allowMultiple: false,
      );

      if (result != null) {
        final imageFile = result.toFile();
        await _saveImageToDataset(imageFile);
      }
    }
    stopLoading();
  }

  Future _saveImageToDataset(File imageFile) async {
    CocoImage? cocoImage = await _coco!.addNewImage(
      imageFile: imageFile,
      imageDirectory: selectedImageDirectory!,
    );
    if (cocoImage != null) {
      bool success = await _coco!.saveAsJson(
        jsonFile: selectedAnnotationFile!,
      );
      if (success) {
        _updateCocoImage(cocoImage);
      } else {
        showAlert(
          header: 'Error',
          text: 'Could not save image to coco configuration json'.translate(),
        );
      }
    }
  }

  Future pickImageDirectory() async {
    final result = await FilePicker.platform.getDirectoryPath(
      initialDirectory: selectedImageDirectory?.path,
    );
    if (result?.isNotEmpty == true) {
      final dir = Directory(result!);
      selectedImageDirectory = dir;
      tryLoadData();
    }
  }

  Future tryLoadData() async {
    if (hasAnnotationFile) {
      try {
        final json = await selectedAnnotationFile!.readAsString();
        _coco = Coco.fromString(json);
        tryOpenLastImage();
        rebuild();
      } on PathAccessException catch (e) {
        showAlert(
          header: 'Could not load annotation file',
          text: e.osError?.message ?? '',
        );
      } catch (e) {
        showAlert(header: 'Error', text: e.toString());
      }
    }
  }

  Future tryOpenLastImage() async {
    await _checkCocoInitialized();
    final lastImageName = await getString('lastImageName');
    if (lastImageName.isEmpty) {
      final CocoImage? firstImage = _coco!.getFirstImage();
      if (firstImage != null) {}
    } else {}
  }

  Future _checkCocoInitialized() async {
    if (_coco == null) {
      /// on this step coco will either be instantiated with a file or
      /// with an empty object but it will be available
      await tryLoadData();
    }
  }

  Future findImage() async {
    await _checkCocoInitialized();
    final imageIds = _coco!.getImageIds();
    final annotations = _coco!.getAnnotations(
      // imageId: 391895,
      // imageId: 558840,
      imageId: imageIds.first,
    );
    final catNames = _coco!.getCategoryNames();
    print(catNames);
  }

  set selectedImageDirectory(Directory? value) {
    if (value != null) {
      if (!value.existsSync()) {
        value.createSync(recursive: true);
      }
    }
    setPersistentValue('selectedImageDirectory', value?.path);
  }

  bool get hasImageDirectory {
    return selectedImageDirectory?.existsSync() == true;
  }

  bool get hasAnnotationFile {
    return selectedAnnotationFile?.existsSync() == true;
  }

  File? get selectedAnnotationFile {
    final path = getPersistentValue<String>('selectedAnnotationFile');
    if (path?.isNotEmpty == true) {
      final file = File(path);
      if (file.existsSync()) {
        return file;
      } else {
        setPersistentValue('selectedAnnotationFile', null);
      }
    }
    return null;
  }

  /// creates a new preset for a dataset in an empty directory
  Future createNewDataset() async {
    final directoryPath = await FilePicker.platform.getDirectoryPath(
      initialDirectory: selectedImageDirectory?.path,
    );
    if (directoryPath?.isNotEmpty == true) {
      final directory = Directory(directoryPath!);
      final listing = directory.listSync();
      if (listing.isNotEmpty) {
        final entryNames = listing.map((e) => e.name).toList();
        final jsons = entryNames.where((e) => e.endsWith('.json')).toList();
        if (jsons.length == 1) {
          final imageDir = listing.firstWhereOrNull((e) => e.name == jsons.first.replaceAll('.json', ''));
          if (imageDir?.existsSync() == true) {
            final confirmed = await showConfirmation(
              header: 'Confirm'.translate(),
              text:
                  '${'This directory already contains data resembling a dataset. Would you like to open '.translate()} ${jsons.first}?',
            );
            if (confirmed) {
              final jsonAnnotationFile = File(directory.combinePath(jsons.first));
              final imageDirectory = Directory(directory.combinePath(
                jsons.first.replaceAll('.json', ''),
              ));
              selectedAnnotationFile = jsonAnnotationFile;
              selectedImageDirectory = imageDirectory;
              rebuild();
              tryLoadData();
              return;
            }
          }
        }
      }
      final fileName = await showNativeInputDialog(
        cancelText: 'Cancel'.translate(),
        confirmText: 'Done'.translate(),
        text: 'Enter new annotation name'.translate(),
        config: NativeInputConfig.string(),
        hintText: 'Enter annotation name'.translate(),
      );
      if (fileName?.isNotEmpty == true) {
        final jsonAnnotationFile = File(directory.combinePath('$fileName.json'));
        final imageDirectory = Directory(directory.combinePath(fileName!));
        selectedAnnotationFile = jsonAnnotationFile;
        selectedImageDirectory = imageDirectory;
        rebuild();
        tryLoadData();
      }
    }
  }

  set selectedAnnotationFile(File? value) {
    if (value != null) {
      if (!value.existsSync()) {
        value.createSync(recursive: true);
      }
    }
    setPersistentValue('selectedAnnotationFile', value?.path);
  }

  Future setString({
    required String key,
    required String? value,
  }) async {
    await setPersistentValue<String?>(key, value);
  }

  /// empty string must also mean that the value is not set.
  /// Just to avoid always checking for null
  Future<String> getString(String key) async {
    return await getPersistentValue<String>(key) ?? '';
  }

  CocoModel? _openedCocoModel;

  @override
  void reset() {}
  @override
  void onLocalStorageInitialized() {}
}
