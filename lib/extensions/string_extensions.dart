import 'package:ai_image_annotator/i18n/ru.dart';

extension StringExtensions on String {
  String toImageAssetPath() {
    return 'assets/images/$this';
  }

  String toSvgAssetPath() {
    return 'assets/svg/$this';
  }

  String translate() {
    return ru[this] ?? this;
  }
}
