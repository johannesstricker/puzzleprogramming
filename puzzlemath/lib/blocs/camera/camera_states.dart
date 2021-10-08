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

class CameraCapture extends CameraInitialized {
  final ui.Image image;

  CameraCapture(this.image);

  @override
  String toString() => 'CameraCapture';
}
