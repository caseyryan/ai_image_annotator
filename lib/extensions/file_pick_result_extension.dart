import 'dart:io';

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
}
extension DirectoryExtension on Directory {
  String combinePath(String part) {
    return '$path/$part'.replaceAll(RegExp(r'[\/]+'), '/');
  }
}