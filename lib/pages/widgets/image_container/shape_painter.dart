import 'package:flutter/material.dart';

class ShapePainter extends CustomPainter {
  final List<List<Offset>> pointVectors;
  final Color shapeColor;

  ShapePainter({
    required this.pointVectors,
    required this.shapeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var list in pointVectors) {
      _drawList(
        canvas: canvas,
        paintColor: shapeColor,
        list: list,
      );
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
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(
        point,
        1.0,
        pointPaint,
      );
    }
  }

  @override
  bool shouldRepaint(ShapePainter oldDelegate) {
    return true;
  }
}
