import 'dart:io';

import 'package:ai_image_annotator/extensions/file_pick_result_extension.dart';
import 'package:ai_image_annotator/extensions/string_extensions.dart';
import 'package:ai_image_annotator/models/coco_model/coco_model.dart';
import 'package:ai_image_annotator/utils/platform_dialogs.dart';
import 'package:lite_forms/lite_forms.dart';

ImageAnnotatorController get imageAnnotatorController {
  return findController<ImageAnnotatorController>();
}

class ImageAnnotatorController extends LiteStateController<ImageAnnotatorController> {
  ImageAnnotatorController() : super(preserveLocalStorageOnControllerDispose: true);

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

  set selectedImageDirectory(Directory? value) {
    setPersistentValue('selectedImageDirectory', value?.path);
  }

  bool get hasImageDirectory {
    return selectedImageDirectory != null;
  }

  bool get hasAnnotationFile {
    return selectedAnnotationFile != null;
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
    final directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath?.isNotEmpty == true) {
      final directory = Directory(directoryPath!);
      // final listing = directory.listSync();
      // if (listing.isNotEmpty) {
      //   final notEmpty = 'Directory is not empty. You cannot create a new dataset in this directory.'.translate();
      //   await FlutterPlatformAlert.showAlert(
      //     windowTitle: 'Error'.translate(),
      //     text: notEmpty,
      //     options: PlatformAlertOptions(),
      //   );
      // }
      final fileName = await showNativeInputDialog(
        cancelText: 'Cancel'.translate(),
        confirmText: 'Done'.translate(),
        text: 'Enter new annotation name'.translate(),
        config: NativeInputConfig.string(),
      );
      if (fileName?.isNotEmpty == true) {
        final jsonAnnotationFile = File(directory.combinePath('$fileName.json'));
        final imageDirectory = Directory(directory.combinePath(fileName!));
        if (!jsonAnnotationFile.existsSync()) {
          jsonAnnotationFile.createSync(recursive: true);
        }
        if (!imageDirectory.existsSync()) {
          imageDirectory.createSync(recursive: true);
        }
        selectedAnnotationFile = jsonAnnotationFile;
        selectedImageDirectory = imageDirectory;
        rebuild();

      }
    }
  }

  set selectedAnnotationFile(File? value) {
    setPersistentValue('selectedAnnotationFile', value?.path);
  }

  CocoModel? _openedCocoModel;

  @override
  void reset() {}
  @override
  void onLocalStorageInitialized() {}
}
