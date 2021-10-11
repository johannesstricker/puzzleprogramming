import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:puzzle_plugin/puzzle_plugin.dart';
import 'package:puzzlemath/math/math.dart';
import 'package:puzzlemath/models/challenge/challenge.dart';
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
  final _cameraBloc = CameraBloc(framesPerSecond: 30);
  late ChallengeBloc _challengeBloc;
  StreamSubscription<CameraState>? _cameraStreamSubscription;

  @override
  void initState() {
    _challengeBloc = ChallengeBloc(
      challenge: widget.challenge,
      // TODO: not sure if this gets the right bloc???
      challengesBloc: BlocProvider.of<ChallengesBloc>(context),
    );
    _cameraBloc.add(InitializeCamera());
    _cameraBloc.stream.listen((CameraState state) {
      if (state is CameraCapture) {
        _challengeBloc.add(ImageReceived(state.image));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _cameraStreamSubscription?.cancel();
    _challengeBloc.close();
    _cameraBloc.close();
    super.dispose();
  }

  Widget _buildStack(BuildContext context,
      {required CameraCapture state, required List<DetectedObject> objects}) {
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
            child: BlocBuilder<ChallengeBloc, ChallengeBlocState>(
              builder:
                  (BuildContext context, ChallengeBlocState challengeState) {
                if (challengeState is ChallengeAttempted) {
                  return DetectionPreview(
                    imageWidth: state.image.width.toDouble(),
                    imageHeight: state.image.height.toDouble(),
                    objects: challengeState.detectedObjects,
                  );
                }
                return Container();
              },
            ),
          ),
        ),
        IgnorePointer(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.all(16),
            alignment: Alignment.bottomCenter,
            child: BlocBuilder<ChallengeBloc, ChallengeBlocState>(
              builder:
                  (BuildContext context, ChallengeBlocState challengeState) {
                if (challengeState is ChallengeAttempted) {
                  return LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Equation(
                          markers: challengeState.getUsedMarkersPadded(
                              widget.challenge.availableMarkers.length),
                          solution: widget.challenge.solution);
                    },
                  );
                }
                return Container();
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CameraBloc>(create: (context) => _cameraBloc),
        BlocProvider<ChallengeBloc>(create: (context) => _challengeBloc),
      ],
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PuzzleAppBar(),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: BlocBuilder<CameraBloc, CameraState>(
              builder: (BuildContext context, CameraState state) {
            if (state is CameraError) {
              return Center(child: Text(state.error));
            }
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
