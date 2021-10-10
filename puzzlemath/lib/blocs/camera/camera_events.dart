import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

abstract class CameraEvent {}

class InitializeCamera extends CameraEvent {
  @override
  String toString() => 'InitializeCamera';
}

class StreamPicture extends CameraEvent {
  final CameraImage image;

  StreamPicture(this.image);

  @override
  String toString() => 'StreamPicture';
}

class FocusCamera extends CameraEvent {
  final Offset point;

  FocusCamera(this.point);

  @override
  String toString() => 'FocusCamera';
}
