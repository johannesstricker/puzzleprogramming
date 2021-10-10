import 'package:camera/camera.dart';
import 'dart:ui' as ui;

abstract class CameraState {}

class CameraUninitialized extends CameraState {
  @override
  String toString() => 'CameraDisabled';
}

class CameraInitialized extends CameraState {
  @override
  String toString() => 'CameraInitialized';
}

class CameraError extends CameraState {
  final String error;

  CameraError(this.error);

  @override
  String toString() => 'CameraError';
}

class CameraCapture extends CameraInitialized {
  final ui.Image image;

  CameraCapture(this.image);

  @override
  String toString() => 'CameraCapture';
}
