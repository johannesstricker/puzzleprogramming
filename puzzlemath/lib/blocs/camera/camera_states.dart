import 'package:camera/camera.dart';

abstract class CameraState {}

class CameraUninitialized extends CameraState {
  @override
  String toString() => 'CameraDisabled';
}

abstract class CameraInitialized extends CameraState {}

class CameraReady extends CameraInitialized {
  @override
  String toString() => 'CameraReady';
}

class CameraBusy extends CameraInitialized {
  final CameraImage image;

  CameraBusy(this.image);

  @override
  String toString() => 'CameraBusy';
}
