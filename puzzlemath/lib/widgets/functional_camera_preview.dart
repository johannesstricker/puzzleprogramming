import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:puzzlemath/blocs/camera/camera_bloc.dart';
import 'package:puzzlemath/blocs/camera/camera_events.dart';
import 'package:puzzlemath/widgets/camera_stream_preview.dart';

class FunctionalCameraPreview extends StatelessWidget {
  final CameraBloc cameraBloc;
  final ui.Image image;

  FunctionalCameraPreview(this.image, {required this.cameraBloc});

  void _onTapDown(TapDownDetails tapDetails, BoxConstraints constraints) {
    final point = Offset(
      tapDetails.localPosition.dx / constraints.maxWidth,
      tapDetails.localPosition.dy / constraints.maxHeight,
    );
    cameraBloc.add(FocusCamera(point));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (details) => _onTapDown(details, constraints),
        child: CameraStreamPreview(image: image),
      );
    });
  }
}
