import 'dart:async';
import 'dart:ui' as ui;
import 'package:rxdart/rxdart.dart';
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
  final Duration _durationPerFrame;
  final ImageBuffer _byteBuffer = ImageBuffer.empty();

  CameraBloc({int framesPerSecond = 30})
      : _durationPerFrame =
            Duration(milliseconds: (1000.0 / framesPerSecond).round()),
        super(CameraUninitialized()) {
    on<InitializeCamera>(_onInitializeCamera);
    on<StreamPicture>(_onStreamPicture);
    on<FocusCamera>(_onFocusCamera);
  }

  // TODO: if the framesPerSecond are too high, the stream will start to lag behind
  EventTransformer<ImageReceived> throttle<ImageReceived>(Duration duration) {
    return (events, mapper) =>
        events.throttleTime(_durationPerFrame).flatMap(mapper);
  }

  void _onInitializeCamera(
      InitializeCamera event, Emitter<CameraState> emit) async {
    try {
      controller?.dispose();
      controller = await _getCameraController();
      await controller!.initialize();
      emit(CameraInitialized());
      controller!.startImageStream((image) => add(StreamPicture(image)));
    } on CameraException catch (error) {
      emit(CameraError(error.toString()));
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

  void _onStreamPicture(StreamPicture event, Emitter<CameraState> emit) async {
    if (state is CameraInitialized) {
      final image = await _convertImage(event.image);
      emit(CameraCapture(image));
    }
  }

  void _onFocusCamera(FocusCamera event, Emitter<CameraState> emit) async {
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
