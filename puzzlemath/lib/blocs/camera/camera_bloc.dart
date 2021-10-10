import 'dart:async';
import 'dart:ui' as ui;
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_plugin/puzzle_plugin.dart';
import 'package:puzzlemath/blocs/camera/camera_events.dart';
import 'package:puzzlemath/blocs/camera/camera_states.dart';
import 'package:camera/camera.dart';

// TODO: handle lifecycle changes?
//       see: https://github.com/flutter/plugins/tree/master/packages/camera/camera#handling-lifecycle-states
Future<CameraController> _getCameraController() async {
  final cameras = await availableCameras();
  return CameraController(cameras.first, ResolutionPreset.medium,
      enableAudio: false, imageFormatGroup: ImageFormatGroup.bgra8888);
}

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  CameraController? controller;
  final num? _millisecondsPerFrame;
  num _frameStartTime = 0;
  final ImageBuffer _byteBuffer = ImageBuffer.empty();

  CameraBloc({framesPerSecond = null})
      : _millisecondsPerFrame =
            framesPerSecond == null ? null : 1000.0 / framesPerSecond,
        super(CameraUninitialized());

  @override
  Stream<CameraState> mapEventToState(CameraEvent event) async* {
    if (event is InitializeCamera) {
      yield* _mapInitializeCameraToState();
    } else if (event is StreamPicture) {
      yield* _mapStreamPictureToState(event);
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
      controller!.startImageStream((image) => add(StreamPicture(image)));
    } on CameraException catch (error) {
      yield CameraError(error.toString());
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

  bool _hasFrameExpired() {
    final currentMilliseconds = DateTime.now().millisecondsSinceEpoch;
    final timePassedInFrame = currentMilliseconds - _frameStartTime;
    if (_millisecondsPerFrame == null ||
        timePassedInFrame > _millisecondsPerFrame!) {
      _frameStartTime = currentMilliseconds;
      return true;
    }
    return false;
  }

  Stream<CameraState> _mapStreamPictureToState(StreamPicture event) async* {
    if (state is CameraInitialized) {
      if (_hasFrameExpired()) {
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
