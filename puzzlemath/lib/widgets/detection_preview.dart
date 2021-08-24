import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:puzzle_plugin/puzzle_plugin.dart';

class DetectionPreview extends CustomPainter {
  DetectionPreview(
      {required this.imageWidth,
      required this.imageHeight,
      required this.color,
      this.detectedObject});

  double imageWidth;
  double imageHeight;
  Color color;
  NativeDetectedObject? detectedObject;

  @override
  void paint(Canvas canvas, Size size) {
    NativeDetectedObject? object = detectedObject;
    if (object == null) return;
    if (object.id < 0) return;

    double scaleX = size.width / imageWidth;
    double scaleY = size.height / imageHeight;

    // TODO: scale to full size of puzzle piece instead of only the size of aruco code
    final points = [
      Offset(object.topLeft!.x * scaleX, object.topLeft!.y * scaleY),
      Offset(object.topRight!.x * scaleX, object.topRight!.y * scaleY),
      Offset(object.bottomRight!.x * scaleX, object.bottomRight!.y * scaleY),
      Offset(object.bottomLeft!.x * scaleX, object.bottomLeft!.y * scaleY),
      Offset(object.topLeft!.x * scaleX, object.topLeft!.y * scaleY)
    ];
    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(PointMode.polygon, points, paint);
  }

  @override
  bool shouldRepaint(DetectionPreview oldDelegate) => true;
}
