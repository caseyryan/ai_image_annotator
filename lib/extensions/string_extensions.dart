import 'package:ai_image_annotator/i18n/ru.dart';

extension StringExtensions on String {
  String toImageAssetPath() {
    return 'assets/images/$this';
  }

  String padIntWithPattern(int value) {
    int length = this.length;
    String paddedValue = value.toString().padLeft(length - 3, '0');

    // Return the padded value with the original pattern length
    return paddedValue.length <= length
        ? paddedValue.padLeft(length, '0')
        : paddedValue.substring(paddedValue.length - length);
  }

  String fileNameToNumericPattern() {
    final match = RegExp(r'[\d]{5,}').firstMatch(this);
    if (match != null) {
      return substring(match.start, match.end);
    }
    return '000000000000';
  }

  String getLastSegmentsOfPath(
    int numSegments, [
    String prefix = '..',
  ]) {
    final segments = split('/');
    final sublistLength = segments.length - numSegments;
    if (sublistLength < 0 || sublistLength == segments.length) {
      return this;
    }
    final result = segments.sublist(sublistLength).join('/');
    return '$prefix/$result';
  }

  String toSvgAssetPath() {
    return 'assets/svg/$this';
  }

  String translate() {
    return ru[this] ?? this;
  }
}
