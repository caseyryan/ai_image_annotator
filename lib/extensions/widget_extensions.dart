import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

extension WidgetExtension on Widget {
  Widget toSliver() {
    return SliverToBoxAdapter(
      child: this,
    );
  }
}

final GlobalKey _repaintBoundaryKey = GlobalKey();
GlobalKey get repaintBoundaryKey => _repaintBoundaryKey;

RenderRepaintBoundary _getRenderRepaintBoundary([
  GlobalKey? boundaryKey,
]) {
  return (boundaryKey ?? _repaintBoundaryKey).currentContext!.findRenderObject() as RenderRepaintBoundary;
}

Future<Uint8List?> takeScreenshotToPngBytes([GlobalKey? boundaryKey, double pixelRatio = 1.0]) async {
  final image = await _getRenderRepaintBoundary(boundaryKey ?? repaintBoundaryKey).toImage(
    pixelRatio: pixelRatio,
  );
  final byteData = await image.toByteData(format: ImageByteFormat.png);
  if (byteData != null) {
    return Uint8List.view(
      byteData.buffer,
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    );
  }
  return null;
}

Future<RawImage> takeScreenshot([
  GlobalKey? boundaryKey,
]) async {
  final image = await _getRenderRepaintBoundary(boundaryKey ?? repaintBoundaryKey).toImage();
  return RawImage(
    image: image,
  );
}
