import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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

class FocusCamera extends CameraEvent {
  final Offset point;

  FocusCamera(this.point);

  @override
  String toString() => 'FocusCamera';
}
