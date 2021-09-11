import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:puzzlemath/blocs/camera/camera_events.dart';
import 'package:puzzlemath/blocs/camera/camera_states.dart';
import 'package:camera/camera.dart';

Future<CameraController> _getCameraController() async {
  final cameras = await availableCameras();
  return CameraController(cameras.first, ResolutionPreset.low,
      enableAudio: false);
}

// TODO: maybe switch to cameraawesome package (https://pub.dev/packages/camerawesome)
class CameraBloc extends Bloc<CameraEvent, CameraState> {
  late final CameraController controller;
  final num _throttle;
  num _busySince = 0;

  CameraBloc(this._throttle) : super(CameraUninitialized());

  @override
  Stream<CameraState> mapEventToState(CameraEvent event) async* {
    if (event is InitializeCamera) {
      yield* _mapInitializeCameraToState();
    } else if (event is TakePicture) {
      yield* _mapTakePictureToState(event);
    }
  }

  Stream<CameraState> _mapInitializeCameraToState() async* {
    try {
      controller = await _getCameraController();
      await controller.initialize();
      yield CameraInitialized();
      controller.startImageStream((image) => add(TakePicture(image)));
    } on CameraException catch (error) {
      // TODO: add CameraError state
      debugPrint(error.description);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Stream<CameraState> _mapTakePictureToState(TakePicture event) async* {
    if (state is CameraInitialized) {
      final currentMilliseconds = DateTime.now().millisecondsSinceEpoch;
      final timePassed = currentMilliseconds - _busySince;
      if (timePassed > _throttle) {
        _busySince = currentMilliseconds;
        yield CameraCapture(event.image);
      }
    }
  }

  @override
  Future<void> close() async {
    await controller.dispose();
    return super.close();
  }
}
