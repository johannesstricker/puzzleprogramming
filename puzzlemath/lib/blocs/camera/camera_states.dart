import 'package:camera/camera.dart';

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
  final CameraImage image;

  CameraCapture(this.image);

  @override
  String toString() => 'CameraBusy';
}
