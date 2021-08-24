import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:puzzle_plugin/puzzle_plugin.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late final CameraController controller;
  bool _isInitialized = false;
  bool _isTakingImage = false;
  num _lastImageProcessedTime = 0;
  String _currentText = "";

  @override
  void initState() {
    super.initState();
    availableCameras().then((cameras) {
      if (cameras.length > 0) {
        _initCameraController(cameras[0]).then((void v) {});
      } else {
        print('No camera available');
      }
    }).catchError((error) {
      print('Error: $error.code\nError Message: $error.message');
    });
  }

  @override
  void dispose() {
    controller.stopImageStream();
    super.dispose();
  }

  Pointer<Uint8> _createImagePlanePointer(Uint8List plane) {
    final buffer = calloc<Uint8>(plane.length);
    final bufferBytes = buffer.asTypedList(plane.length);
    bufferBytes.setAll(0, plane);
    return buffer;
  }

  // NOTE: on iOS the image format is 32BGRA; on Android it's YUV_420_888

  void _onImageReceived(CameraImage image) {
    if (_isTakingImage) return;

    final throttleMilliseconds = 1000;
    final currentMilliseconds = DateTime.now().millisecondsSinceEpoch;
    final millisecondsPassed = _lastImageProcessedTime == 0
        ? throttleMilliseconds
        : currentMilliseconds - _lastImageProcessedTime;
    final isTimedOut = millisecondsPassed >= throttleMilliseconds;
    if (isTimedOut) {
      setState(() {
        _isTakingImage = true;
      });

      final imageBytes = _createImagePlanePointer(image.planes[0].bytes);
      // final bytesPerPixel = image.planes[0].bytesPerPixel;
      final width = image.planes[0].width!;
      final height = image.planes[0].height!;
      final bytesPerRow = image.planes[0].bytesPerRow;
      // PuzzlePlugin.detectAndDecodeArUco32BGRA(
      PuzzlePlugin.detectObject32BGRA(imageBytes, width, height, bytesPerRow)
          .then((NativeDetectedObject content) {
        _currentText = content.id.toString();
        calloc.free(imageBytes);
        setState(() {
          _isTakingImage = false;
          _lastImageProcessedTime = currentMilliseconds;
        });
      });
    }
  }

  Future _initCameraController(CameraDescription description) async {
    controller = CameraController(description, ResolutionPreset.high);
    try {
      await controller.initialize();
      controller.startImageStream(_onImageReceived);
      setState(() {
        _isInitialized = true;
      });
    } on CameraException catch (error) {
      print('Camera exception: $error');
    }
  }

  Widget _buildCameraPreview(BuildContext context) {
    return Stack(children: [
      Container(
        height: double.infinity,
        width: double.infinity,
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(5.0),
        alignment: Alignment.bottomCenter,
        child: Text(
          _currentText,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 14.0),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take a picture'),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: _isInitialized ? _buildCameraPreview(context) : Container(),
      ),
    );
  }
}
