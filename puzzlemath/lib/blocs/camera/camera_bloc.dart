import 'dart:async';
import 'dart:ui' as ui;
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_plugin/puzzle_plugin.dart';
import 'package:puzzlemath/blocs/camera/camera_events.dart';
import 'package:puzzlemath/blocs/camera/camera_states.dart';
import 'package:camera/camera.dart';

// TODO: handle lifecycle changes
//       see: https://github.com/flutter/plugins/tree/master/packages/camera/camera#handling-lifecycle-states
Future<CameraController> _getCameraController() async {
  final cameras = await availableCameras();
  return CameraController(cameras.first, ResolutionPreset.medium,
      enableAudio: false, imageFormatGroup: ImageFormatGroup.bgra8888);
}

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraController? controller;
  final num _throttle;
  num _busySince = 0;
  final ImageBuffer _byteBuffer = ImageBuffer.empty();

  CameraBloc(this._throttle) : super(CameraUninitialized());

  @override
  Stream<CameraState> mapEventToState(CameraEvent event) async* {
    if (event is InitializeCamera) {
      yield* _mapInitializeCameraToState();
    } else if (event is TakePicture) {
      yield* _mapTakePictureToState(event);
    } else if (event is FocusCamera) {
      yield* _mapFocusCameraToState(event);
    }
  }

  Stream<CameraState> _mapInitializeCameraToState() async* {
    try {
      controller?.dispose();
      controller = await _getCameraController();
      await controller!.initialize();
      yield CameraInitialized();
      controller!.startImageStream((image) => add(TakePicture(image)));
    } on CameraException catch (error) {
      // TODO: add CameraError state
      debugPrint(error.description);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<ui.Image> _convertImage(CameraImage image) {
    Completer<ui.Image> result = new Completer();

    _byteBuffer.update(image);
    ui.decodeImageFromPixels(
      _byteBuffer.asTypedList(),
      _byteBuffer.width,
      _byteBuffer.height,
      ui.PixelFormat.bgra8888,
      result.complete,
    );
    return result.future;
  }

  Stream<CameraState> _mapTakePictureToState(TakePicture event) async* {
    if (state is CameraInitialized) {
      final currentMilliseconds = DateTime.now().millisecondsSinceEpoch;
      final timePassed = currentMilliseconds - _busySince;

      if (timePassed > _throttle) {
        _busySince = currentMilliseconds;

        final image = await _convertImage(event.image);
        yield CameraCapture(image);
      }
    }
  }

  Stream<CameraState> _mapFocusCameraToState(FocusCamera event) async* {
    if (state is CameraInitialized) {
      controller?.setExposurePoint(event.point);
      controller?.setFocusPoint(event.point);
      controller?.setFocusMode(FocusMode.locked);
    }
  }

  @override
  Future<void> close() async {
    _byteBuffer.free();
    await controller?.dispose();
    return super.close();
  }
}
