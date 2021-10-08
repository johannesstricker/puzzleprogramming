import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:puzzle_plugin/puzzle_plugin.dart';
import 'package:puzzlemath/math/math.dart';
import 'package:puzzlemath/models/challenge/challenge.dart';
import 'package:puzzlemath/screens/solution_screen.dart';
import 'package:puzzlemath/widgets/app_bar.dart';
import 'package:puzzlemath/widgets/detection_preview.dart';
import 'package:puzzlemath/widgets/equation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzlemath/blocs/blocs.dart';
import 'package:puzzlemath/widgets/functional_camera_preview.dart';

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

  bool _isSolved = false;
  List<Marker>? _usedMarkers;
  int? _proposedSolution;

  double imageWidth = 0;
  double imageHeight = 0;
  List<DetectedObject> detectedObjects = const [];

  @override
  void initState() {
    _cameraBloc.add(InitializeCamera());
    super.initState();
  }

  @override
  void dispose() {
    _cameraStreamSubscription?.cancel();
    _cameraBloc.close();
    super.dispose();
  }

  // TODO: use old AST for a while when parsing fails to avoid spurious errors
  // TODO: this should not be part of the state and instead be built in a
  //       streambuilder or bloc builder
  void _onImageReceived(ui.Image image) async {
    final objects = await PuzzlePlugin.detectObjectsAsync(image);
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
    });

    if (proposedSolution == widget.challenge.solution) {}
  }

  Widget _buildStack(BuildContext context,
      {required CameraCapture state, required List<DetectedObject> objects}) {
    final List<Marker> detectedMarkers =
        widget.challenge.availableMarkers.asMap().entries.map((entry) {
      final index = entry.key;
      final detectedMarker = index < objects.length
          ? createMarker(objects[index].id)
          : Marker.Unknown;
      return detectedMarker;
    }).toList();

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: FunctionalCameraPreview(
            state.image,
            cameraBloc: _cameraBloc,
          ),
        ),
        IgnorePointer(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: DetectionPreview(
              imageWidth: state.image.width.toDouble(),
              imageHeight: state.image.height.toDouble(),
              objects: objects,
            ),
          ),
        ),
        IgnorePointer(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.all(16),
            alignment: Alignment.bottomCenter,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Equation(markers: detectedMarkers, solution: 1337);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCameraPreview(BuildContext context, CameraState state) {
    if (state is CameraCapture) {
      // _attempt(context);

      final objects =
          PuzzlePlugin.detectObjectsAsync(state.image).then((objects) {
        final sortedObjects = sortObjectListLTR(objects);
        return sortedObjects;
      });

      return FutureBuilder(
        future: objects,
        builder: (BuildContext context,
            AsyncSnapshot<List<DetectedObject>> snapshot) {
          if (snapshot.hasData) {
            return _buildStack(
              context,
              objects: snapshot.data!,
              state: state,
            );
          }
          return Container(color: Colors.black);
        },
      );
    }
    return Container(color: Colors.black);
  }

  void _attempt(BuildContext context) {
    if (_proposedSolution == null || _usedMarkers == null) {
      return;
    }
    // TODO: push to success or error route
    bool challengeSolved =
        widget.challenge.checkSolution(_proposedSolution!, _usedMarkers!);
    if (challengeSolved && !_isSolved) {
      // TODO: all this logic should live inside a bloc
      _isSolved = true;
      Future.microtask(() {
        BlocProvider.of<ChallengesBloc>(context)
            .add(SolveChallenge(widget.challenge));
        // TODO: don't push
        Navigator.pushNamed(
          context,
          SolutionScreen.routeName,
          arguments: SolutionScreenArguments(
              proposedSolution: _proposedSolution!,
              usedMarkers: _usedMarkers!,
              challenge: widget.challenge),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CameraBloc>(
      create: (context) => _cameraBloc,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PuzzleAppBar(),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: BlocBuilder<CameraBloc, CameraState>(
              builder: (BuildContext context, CameraState state) {
            if (state is CameraInitialized) {
              return _buildCameraPreview(context, state);
            }
            return Container();
          }),
        ),
      ),
    );
  }
}
