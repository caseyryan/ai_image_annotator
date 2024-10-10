import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:lite_forms/lite_forms.dart';

extension FilePickerResultExtension on FilePickerResult {
  List<File> toFilesList() {
    return files.map((e) => File(e.path!)).toList();
  }

  File toFile() {
    return toFilesList().first;
  }
}

extension FileExtension on File {
  String get name {
    return path.split('/').last;
  }

  Future<ImageDimensions?> getImageDimensions() async {
    final bytes = await readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image != null) {
      return ImageDimensions(
        width: image.width,
        height: image.height,
      );
    }
    return null;
  }

  Future<bool> encodeImageToJpgResizeAndSave({
    required String outputPath,
    int quality = 100,
    int maxWidth = 640,
    int maxHeight = 640,
  }) async {
    final bytes = await readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image != null) {
      int originalWidth = image.width;
      int originalHeight = image.height;

      double aspectRatio = originalWidth / originalHeight;
      int newWidth;
      int newHeight;

      if (originalWidth > originalHeight) {
        // Landscape orientation
        newWidth = maxWidth;
        newHeight = (maxWidth / aspectRatio).round();
        if (newHeight > maxHeight) {
          newHeight = maxHeight;
          newWidth = (maxHeight * aspectRatio).round();
        }
      } else {
        // Portrait orientation
        newHeight = maxHeight;
        newWidth = (maxHeight * aspectRatio).round();
        if (newWidth > maxWidth) {
          newWidth = maxWidth;
          newHeight = (maxWidth / aspectRatio).round();
        }
      }

      img.Image resizedImage = img.copyResize(
        image,
        width: newWidth,
        height: newHeight,
        interpolation: img.Interpolation.cubic,
      );

      List<int> jpg = img.encodeJpg(
        resizedImage,
        quality: quality,
      );
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(jpg);
      return true;
    }
    return false;
  }
}

extension DirectoryExtension on Directory {
  String combinePath(String part) {
    return '$path/$part'.replaceAll(RegExp(r'[\/]+'), '/');
  }
}

class ImageDimensions {
  ImageDimensions({
    required this.width,
    required this.height,
  });

  final int width;
  final int height;
}
