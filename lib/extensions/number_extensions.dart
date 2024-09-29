import 'package:ai_image_annotator/theme_extensions/custom_color_theme.dart';
import 'package:flutter/material.dart';
import 'package:lite_forms/intl_local/lib/intl.dart';

extension IntExtension on int {
  Color toColor() {
    return Color(this);
  }

  String toPercent() {
    return '$this%';
  }

  String formatMilliseconds() {
    final date = DateTime(0, 0, 0, 0, 0, 0, this);
    if (date.hour > 0) {
      return DateFormat('HH:mm:ss.SSS').format(date);
    }
    return DateFormat('mm:ss.SSS').format(date);
  }

  String formatSeconds() {
    final date = DateTime(0, 0, 0, 0, 0, this);
    if (date.hour > 0) {
      return DateFormat('HH:mm:ss').format(date);
    }
    return DateFormat('mm:ss').format(date);
  }

  Color percentProgressToColor(BuildContext context) {
    final theme = CustomColorTheme.of(context);
    if (this < 50) {
      return Color.lerp(
        theme.negativeColor,
        theme.warningColor,
        this / 100.0,
      )!;
    }
    return Color.lerp(
      theme.warningColor,
      theme.positiveColor,
      this / 100.0,
    )!;
  }

  Color percentToBackgroundColor(BuildContext context) {
    return Theme.of(context).canvasColor;
  }
}
