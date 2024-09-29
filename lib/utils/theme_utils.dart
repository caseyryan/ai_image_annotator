import 'dart:math';

import 'package:ai_image_annotator/constants.dart';
// ignore: depend_on_referenced_packages
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

BorderRadius adaptiveRadius([
  double? elementHeight,
]) {
  return SmoothBorderRadius.all(
    SmoothRadius(
      cornerRadius: elementHeight != null
          ? min(
              kBorderRadius,
              elementHeight * .20,
            )
          : kBorderRadius,
      cornerSmoothing: 1.0,
    ),
  );
}
