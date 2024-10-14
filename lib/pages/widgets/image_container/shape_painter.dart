import 'package:ai_image_annotator/lite_state/single_use_controllers/image_container_controller.dart';
import 'package:ai_image_annotator/models/coco_model/coco_annotation.dart';
import 'package:flutter/material.dart';

class ShapePainter extends CustomPainter {
  final VectorWrapper activeVectorWrapper;
  final List<VectorWrapper> inactivePointVectors;

  ShapePainter({
    required this.activeVectorWrapper,
    required this.inactivePointVectors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var list in activeVectorWrapper.points) {
      final CocoAnnotation? annotation = activeVectorWrapper.annotation;
      if (annotation == null) {
        break;
      }
      _drawList(
        canvas: canvas,
        paintColor: annotation.color,
        list: list,
        drawPoints: true,
      );
    }
    for (var vectorWrapper in inactivePointVectors) {
      final CocoAnnotation? annotation = vectorWrapper.annotation;
      if (annotation == null) {
        break;
      }
      for (var points in vectorWrapper.points) {
        _drawList(
          canvas: canvas,
          paintColor: annotation.color,
          list: points,
          drawPoints: true,
        );
      }
    }
  }

  void _drawList({
    required Canvas canvas,
    required List<Offset> list,
    required Color paintColor,
    bool drawPoints = true,
  }) {
    /// draw fill
    final Path fillPath = Path();
    final Path strokePath = Path();
    final Paint fillPaint = Paint()
      ..color = paintColor.withOpacity(.3)
      ..style = PaintingStyle.fill;
    final Paint strokePaint = Paint()
      ..color = paintColor.withOpacity(.8)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    var points = <Offset>[];
    if (list.isNotEmpty) {
      var posX = list[0].dx;
      var posY = list[0].dy;

      points.add(Offset(posX, posY));

      fillPath.moveTo(posX, posY);
      strokePath.moveTo(posX, posY);
      for (int i = 1; i < list.length; i++) {
        posX = list[i].dx;
        posY = list[i].dy;
        points.add(Offset(posX, posY));

        fillPath.lineTo(posX, posY);
        strokePath.lineTo(posX, posY);
      }

      fillPath.close();
      strokePath.close();

      canvas.drawPath(fillPath, fillPaint);
      canvas.drawPath(strokePath, strokePaint);
      for (var point in points) {
        _drawPoint(
          canvas: canvas,
          point: point,
          drawPoint: drawPoints,
        );
      }
    }
  }

  void _drawPoint({
    required Canvas canvas,
    required Offset point,
    bool drawPoint = true,
  }) {
    if (drawPoint) {
      final Paint pointPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = .5
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(
        point,
        .2,
        pointPaint,
      );
    }
  }

  @override
  bool shouldRepaint(ShapePainter oldDelegate) {
    return false;
  }
}
