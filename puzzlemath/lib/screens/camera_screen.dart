import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_plugin/puzzle_plugin.dart';
import 'package:puzzlemath/math/math.dart';
import 'package:puzzlemath/math/challenge.dart';
import 'package:puzzlemath/screens/solution_screen.dart';
import '../widgets/detection_preview.dart';

class CameraScreenArguments {
  final Challenge challenge;

  CameraScreenArguments({required this.challenge});
}

class CameraScreen extends StatefulWidget {
  static const routeName = '/camera';

  final Challenge challenge;

  CameraScreen(CameraScreenArguments args) : challenge = args.challenge;

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late final CameraController controller;
  bool _isInitialized = false;
  bool _isTakingImage = false;
  bool _isButtonEnabled = false;
  num _lastImageProcessedTime = 0;
  List<Marker>? _usedMarkers;
  int? _proposedSolution;

  ImageBuffer _imageBuffer = ImageBuffer.empty();

  double imageWidth = 0;
  double imageHeight = 0;
  Color color = Colors.greenAccent;
  List<DetectedObject> detectedObjects = const [];

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
    _imageBuffer.free();
    super.dispose();
  }

  void _onImageReceived(CameraImage image) {
    if (_isTakingImage) return;

    final throttleMilliseconds = 100;
    final currentMilliseconds = DateTime.now().millisecondsSinceEpoch;
    final millisecondsPassed = _lastImageProcessedTime == 0
        ? throttleMilliseconds
        : currentMilliseconds - _lastImageProcessedTime;
    final isTimedOut = millisecondsPassed >= throttleMilliseconds;
    if (isTimedOut) {
      _isTakingImage = true;

      _imageBuffer.update(image);
      PuzzlePlugin.detectObjects(_imageBuffer)
          .then((List<DetectedObject> objects) {
        final sortedObjects = sortObjectListLTR(objects);
        int? proposedSolution;
        try {
          proposedSolution = parseAbstractSyntaxTreeFromObjects(sortedObjects);
        } catch (error) {}

        setState(() {
          imageWidth = image.width.toDouble();
          imageHeight = image.height.toDouble();
          detectedObjects = sortedObjects;
          _proposedSolution = proposedSolution;
          _usedMarkers =
              sortedObjects.map((obj) => createMarker(obj.id)).toList();
          _isTakingImage = false;
          _isButtonEnabled = proposedSolution != null;
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

  // TODO: set focus mode on screen tap
  ////     e.g. await camera.setFocusPoint(cameraId, Point<double>(0.5, 0.5));
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
          height: double.infinity,
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CustomPaint(
                painter: DetectionPreview(
                    imageWidth: this.imageWidth,
                    imageHeight: this.imageHeight,
                    color: this.color,
                    objects: this.detectedObjects)),
          )),
    ]);
  }

  Widget buildFloatingActionButton(BuildContext context) {
    final opacity = _isButtonEnabled ? 1.0 : 0.1;
    final onPressed = _isButtonEnabled
        ? () {
            if (_proposedSolution == null || _usedMarkers == null) {
              return;
            }
            // TODO: don't push
            Navigator.pushNamed(
              context,
              SolutionScreen.routeName,
              arguments: SolutionScreenArguments(
                  proposedSolution: _proposedSolution!,
                  usedMarkers: _usedMarkers!,
                  challenge: widget.challenge),
            );
          }
        : null;
    return Opacity(
      opacity: opacity,
      child: FloatingActionButton(
        onPressed: onPressed,
        child: Icon(Icons.camera),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take a picture'),
        centerTitle: true,
      ),
      floatingActionButton: buildFloatingActionButton(context),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: _isInitialized ? _buildCameraPreview(context) : Container(),
      ),
    );
  }
}
