import 'package:camera/camera.dart';

abstract class CameraEvent {}

class InitializeCamera extends CameraEvent {
  @override
  String toString() => 'InitializeCamera';
}

class TakePicture extends CameraEvent {
  final CameraImage image;

  TakePicture(this.image);

  @override
  String toString() => 'TakePicture';
}
