import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:puzzlemath/theme/colors.dart';

class CameraStreamPreview extends StatelessWidget {
  final BoxFit fit;
  final Alignment alignment;
  final ui.Image? image;

  CameraStreamPreview({
    required this.image,
    this.fit: BoxFit.cover,
    this.alignment: Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return Container(color: ColorNeutral100);
    }
    return RawImage(
      image: image,
      fit: fit,
      alignment: Alignment.center,
    );
  }
}
