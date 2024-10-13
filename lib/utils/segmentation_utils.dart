import 'dart:ui';

/// Calculate areas for Coco annotation segmentation
double calculatePolygonArea(
  List<List<double>>? segmentation,
) {
  if (segmentation?.isNotEmpty != true) {
    return 0.0;
  }
  double totalArea = 0.0;

  for (var points in segmentation!) {
    /// Ensure the points list has an even length for proper (x, y) pairing
    if (points.length % 2 != 0) continue;

    List<double> xCoords = [];
    List<double> yCoords = [];

    for (int i = 0; i < points.length; i++) {
      if (i % 2 == 0) {
        xCoords.add(points[i]);
      } else {
        yCoords.add(points[i]);
      }
    }

    /// Calculate the area using the shoelace formula
    double area = 0.0;
    int n = xCoords.length;

    for (int i = 0; i < n; i++) {
      int j = (i + 1) % n;

      /// Wrap around to the first point
      area += xCoords[i] * yCoords[j];
      area -= yCoords[i] * xCoords[j];
    }

    area = (area.abs()) / 2.0;
    totalArea += area;
  }

  return totalArea;
}

List<List<int>> createBinaryMask(
  List<List<double>> segmentation,
  int imageWidth,
  int imageHeight,
) {
  List<List<int>> mask = List.generate(
    imageHeight,
    (_) => List.generate(imageWidth, (_) => 0),
  );

  for (var points in segmentation) {
    if (points.length % 2 != 0) continue;

    /// Prepare the polygon points
    List<Offset> polygonPoints = [];
    for (int i = 0; i < points.length; i += 2) {
      double x = points[i];
      double y = points[i + 1];
      polygonPoints.add(Offset(x, y));
    }

    /// Fill the polygon into the mask using a rasterization method
    _fillPolygonInMask(mask, polygonPoints);
  }

  return mask;
}

List<int> segmentationToRLE(
  List<List<double>>? segmentation,
  int imageWidth,
  int imageHeight,
) {
  if (segmentation?.isNotEmpty != true) {
    return [];
  }
  final binaryMask = createBinaryMask(
    segmentation!,
    imageWidth,
    imageHeight,
  );
  return _rleEncode(binaryMask);
}

List<int> _rleEncode(
  List<List<int>> binaryMask,
) {
  // Flatten the 2D binary mask into a 1D list
  List<int> flattenedMask = [];
  for (var row in binaryMask) {
    flattenedMask.addAll(row);
  }

  List<int> rle = [];
  int count = 1;

  for (int i = 1; i <= flattenedMask.length; i++) {
    if (i == flattenedMask.length || flattenedMask[i] != flattenedMask[i - 1]) {
      rle.add(count);
      rle.add(i - count + 1);
      count = 1;
    } else {
      count++;
    }
  }

  return rle;
}

void _fillPolygonInMask(
  List<List<int>> mask,
  List<Offset> polygon,
) {
  int n = polygon.length;

  /// invalid polygon
  if (n < 3) return;

  /// bounding box for the polygon
  int minX = polygon.map((p) => p.dx.toInt()).reduce((a, b) => a < b ? a : b);
  int maxX = polygon.map((p) => p.dx.toInt()).reduce((a, b) => a > b ? a : b);
  int minY = polygon.map((p) => p.dy.toInt()).reduce((a, b) => a < b ? a : b);
  int maxY = polygon.map((p) => p.dy.toInt()).reduce((a, b) => a > b ? a : b);

  /// Iterate through the bounding box and check if each point is inside the polygon
  for (int y = minY; y <= maxY; y++) {
    for (int x = minX; x <= maxX; x++) {
      if (_isPointInPolygon(x, y, polygon)) {
        if (y >= 0 && y < mask.length && x >= 0 && x < mask[0].length) {
          /// Set the mask point to 1 (foreground)
          mask[y][x] = 1;
        }
      }
    }
  }
}

bool _isPointInPolygon(
  int x,
  int y,
  List<Offset> polygon,
) {
  int n = polygon.length;
  bool inside = false;

  for (int i = 0, j = n - 1; i < n; j = i++) {
    Offset pi = polygon[i];
    Offset pj = polygon[j];

    if ((pi.dy > y) != (pj.dy > y) && (x < (pj.dx - pi.dx) * (y - pi.dy) / (pj.dy - pi.dy) + pi.dx)) {
      inside = !inside;
    }
  }
  return inside;
}

/// Supports both List<int> and String RLEs
List<List<double>> rleToContours(Map rle) {
  List<int> counts;
  if (rle['counts'] is List) {
    counts = List<int>.from(rle['counts']);
  } else {
    // TODO: Decode string to list
    counts = [];
  }
  List<int> size = List<int>.from(rle['size']);

  int width = size[0];
  int height = size[1];

  List<List<double>> contours = [];

  for (int i = 0; i < counts.length; i += 2) {
    if (i + 1 >= counts.length) {
      break;
    }

    int length = counts[i];
    int start = counts[i + 1];
    for (int j = 0; j < length; j++) {
      int index = start + j;
      if (index < 0 || index >= width * height) {
        continue;
      }

      int x = index % width;
      int y = index ~/ width;

      contours.add([x.toDouble(), y.toDouble()]);
    }
  }

  return contours;
}
