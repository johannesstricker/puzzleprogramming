import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:puzzlemath/blocs/camera/camera_bloc.dart';
import 'package:puzzlemath/blocs/camera/camera_events.dart';

class FunctionalCameraPreview extends StatelessWidget {
  final CameraBloc cameraBloc;
  final CameraController controller;

  FunctionalCameraPreview(this.controller, {required this.cameraBloc});

  void _onTapDown(TapDownDetails tapDetails, BoxConstraints constraints) {
    final point = Offset(
      tapDetails.localPosition.dx / constraints.maxWidth,
      tapDetails.localPosition.dy / constraints.maxHeight,
    );
    cameraBloc.add(FocusCamera(point));
  }

  @override
  Widget build(BuildContext context) {
    return CameraPreview(
      controller,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) => _onTapDown(details, constraints),
        );
      }),
    );
  }
}
