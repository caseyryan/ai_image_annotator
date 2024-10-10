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

  Future<bool> encodeImageToJpg({
    required String outputPath,
    int quality = 100,
  }) async {
    final bytes = await readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image != null) {
      List<int> jpg = img.encodeJpg(
        image,
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
