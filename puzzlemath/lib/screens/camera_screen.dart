import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_plugin/puzzle_plugin.dart';
import 'package:puzzlemath/math/math.dart';
import 'package:puzzlemath/models/challenge/challenge.dart';
import 'package:puzzlemath/screens/solution_screen.dart';
import 'package:puzzlemath/widgets/app_bar.dart';
import 'package:puzzlemath/widgets/button.dart';
import 'package:puzzlemath/widgets/detection_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzlemath/blocs/blocs.dart';

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
  final CameraBloc _cameraBloc = CameraBloc(10);
  StreamSubscription<CameraState>? _cameraStreamSubscription;

  bool _isButtonEnabled = false;
  List<Marker>? _usedMarkers;
  int? _proposedSolution;

  ImageBuffer _imageBuffer = ImageBuffer.empty();

  double imageWidth = 0;
  double imageHeight = 0;
  Color color = Colors.greenAccent;
  List<DetectedObject> detectedObjects = const [];

  @override
  void initState() {
    _cameraBloc.add(InitializeCamera());
    _cameraStreamSubscription = _cameraBloc.stream.listen((CameraState state) {
      if (state is CameraCapture) {
        _onImageReceived(state.image);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _imageBuffer.free();
    _cameraStreamSubscription?.cancel();
    _cameraBloc.close();
    super.dispose();
  }

  // TODO: use old AST for a while when parsing fails to avoid spurious errors
  void _onImageReceived(CameraImage image) {
    _imageBuffer.update(image);
    final objects = PuzzlePlugin.detectObjects(_imageBuffer);
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
      _usedMarkers = sortedObjects.map((obj) => createMarker(obj.id)).toList();
      _isButtonEnabled = proposedSolution != null;
    });
  }

  void _onScreenTap(TapDownDetails tapDetails, BoxConstraints constraints) {
    final point = Offset(
      tapDetails.localPosition.dx / constraints.maxWidth,
      tapDetails.localPosition.dy / constraints.maxHeight,
    );
    _cameraBloc.add(FocusCamera(point));
  }

  // TODO: fix aspect ratio of camera image (use the camera_awesome package)
  Widget _buildCameraPreview(BuildContext context) {
    final controller = BlocProvider.of<CameraBloc>(context).controller!;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: AspectRatio(
            aspectRatio: 1.0 / controller.value.aspectRatio,
            child: CameraPreview(
              controller,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (details) => _onScreenTap(details, constraints),
                );
              }),
            ),
          ),
        ),
        IgnorePointer(
          child: Container(
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
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    final opacity = _isButtonEnabled ? 1.0 : 0.1;
    final onPressed = _isButtonEnabled
        ? () {
            if (_proposedSolution == null || _usedMarkers == null) {
              return;
            }
            // TODO: push to success or error route
            bool challengeSolved = widget.challenge
                .checkSolution(_proposedSolution!, _usedMarkers!);
            if (challengeSolved) {
              BlocProvider.of<ChallengesBloc>(context)
                  .add(SolveChallenge(widget.challenge));
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
      child: Button.Primary(
        onPressed: onPressed,
        icon: Icons.camera,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CameraBloc>(
      create: (context) => _cameraBloc,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PuzzleAppBar(),
        floatingActionButton: buildFloatingActionButton(context),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: BlocBuilder<CameraBloc, CameraState>(
              builder: (BuildContext context, CameraState state) {
            if (state is CameraInitialized) {
              return _buildCameraPreview(context);
            }
            return Container();
          }),
        ),
      ),
    );
  }
}
