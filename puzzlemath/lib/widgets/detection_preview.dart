import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:puzzle_plugin/puzzle_plugin.dart';
import 'package:puzzlemath/theme/colors.dart';

class DetectionPreviewPainter extends CustomPainter {
  DetectionPreviewPainter(
      {required this.imageWidth,
      required this.imageHeight,
      this.objects = const []});

  double imageWidth;
  double imageHeight;
  List<DetectedObject> objects;

  @override
  void paint(Canvas canvas, Size size) {
    double scaleX = size.width / imageWidth;
    double scaleY = size.height / imageHeight;
    double scale = scaleX > scaleY ? scaleX : scaleY;

    Offset offset = Offset(
      (imageWidth * scale - size.width) / 2,
      (imageHeight * scale - size.height) / 2,
    );

    objects.forEach((obj) => paintDetectedObject(canvas, obj, scale, offset));
  }

  void paintDetectedObject(
      Canvas canvas, DetectedObject object, double scale, Offset offset) {
    // TODO: scale to full size of puzzle piece instead of only the size of aruco code
    final points = [
      Offset(object.topLeft.x * scale, object.topLeft.y * scale) - offset,
      Offset(object.topRight.x * scale, object.topRight.y * scale) - offset,
      Offset(object.bottomRight.x * scale, object.bottomRight.y * scale) -
          offset,
      Offset(object.bottomLeft.x * scale, object.bottomLeft.y * scale) - offset,
      Offset(object.topLeft.x * scale, object.topLeft.y * scale) - offset
    ];
    final paint = Paint()
      ..color = ColorSecondary.withOpacity(0.5)
      ..strokeWidth = 4
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.square;
    canvas.drawPoints(PointMode.polygon, points, paint);
  }

  @override
  bool shouldRepaint(DetectionPreviewPainter oldDelegate) => true;
}

class DetectionPreview extends StatelessWidget {
  final double imageWidth, imageHeight;
  final List<DetectedObject> objects;

  DetectionPreview(
      {required this.imageWidth,
      required this.imageHeight,
      required this.objects});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DetectionPreviewPainter(
        imageWidth: imageWidth,
        imageHeight: imageHeight,
        objects: objects,
      ),
    );
  }
}
