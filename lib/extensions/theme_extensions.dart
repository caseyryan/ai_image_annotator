import 'package:ai_image_annotator/navigator_utils.dart';
import 'package:ai_image_annotator/theme_extensions/custom_text_theme.dart';
import 'package:flutter/material.dart';

TextStyle get normalTextStyle {
  return CustomTextTheme.of(appContext).defaultStyle;
}
TextStyle get boldTextStyle {
  return CustomTextTheme.of(appContext).defaultStyle.copyWith(
    fontWeight: FontWeight.bold,
  );
}
TextStyle get hugeHeaderStyle {
  return Theme.of(appContext).headerStyle.copyWith(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
  );
}
TextStyle get smallTextStyle{
  return Theme.of(appContext).smallTextStyle;
}

extension ThemeDataExtension on ThemeData {
  Color get secondaryColor {
    return colorScheme.secondary;
  }

  Color get cardBackgroundColor {
    return dialogBackgroundColor;
  }

  TextStyle get normalTextStyle {
    return extension<CustomTextTheme>()!.defaultStyle;
  }

  TextStyle get headerStyle {
    return extension<CustomTextTheme>()!.headerStyle;
  }

  TextStyle get smallTextStyle {
    return extension<CustomTextTheme>()!.captionStyle;
  }

  TextStyle get mediumTextStyle {
    return extension<CustomTextTheme>()!.descriptionStyle;
  }
}
