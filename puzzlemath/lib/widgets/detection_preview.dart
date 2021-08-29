import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:puzzle_plugin/puzzle_plugin.dart';
import 'dart:ffi';

class DetectionPreview extends CustomPainter {
  DetectionPreview(
      {required this.imageWidth,
      required this.imageHeight,
      required this.color,
      this.objects = const []});

  double imageWidth;
  double imageHeight;
  Color color;
  List<DetectedObject> objects;

  @override
  void paint(Canvas canvas, Size size) {
    double scaleX = size.width / imageWidth;
    double scaleY = size.height / imageHeight;
    objects.forEach((obj) => paintDetectedObject(canvas, obj, scaleX, scaleY));
  }

  void paintDetectedObject(
      Canvas canvas, DetectedObject object, double scaleX, double scaleY) {
    // TODO: scale to full size of puzzle piece instead of only the size of aruco code
    final points = [
      Offset(object.topLeft.x * scaleX, object.topLeft.y * scaleY),
      Offset(object.topRight.x * scaleX, object.topRight.y * scaleY),
      Offset(object.bottomRight.x * scaleX, object.bottomRight.y * scaleY),
      Offset(object.bottomLeft.x * scaleX, object.bottomLeft.y * scaleY),
      Offset(object.topLeft.x * scaleX, object.topLeft.y * scaleY)
    ];
    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.square;
    canvas.drawPoints(PointMode.polygon, points, paint);
  }

  @override
  bool shouldRepaint(DetectionPreview oldDelegate) => true;
}
