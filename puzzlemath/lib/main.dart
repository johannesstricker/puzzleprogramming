import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzlemath/blocs/challenges/challenges.dart';
import 'screens/camera_screen.dart';
import 'screens/challenge_list_screen.dart';
import 'screens/challenge_screen.dart';
import 'screens/solution_screen.dart';
import 'config/navigation.dart';

void main() {
  runApp(PuzzleApp());
}

ChallengeListScreen buildChallengeListScreen(context) {
  return ChallengeListScreen();
}

CameraScreen buildCameraScreen(context) {
  final args =
      ModalRoute.of(context)!.settings.arguments as CameraScreenArguments;
  return CameraScreen(args);
}

ChallengeScreen buildChallengeScreen(context) {
  final args =
      ModalRoute.of(context)!.settings.arguments as ChallengeScreenArguments;
  return ChallengeScreen(args);
}

SolutionScreen buildSolutionScreen(context) {
  final args =
      ModalRoute.of(context)!.settings.arguments as SolutionScreenArguments;
  return SolutionScreen(args);
}

class PuzzleApp extends StatefulWidget {
  @override
  _PuzzleAppState createState() => _PuzzleAppState();
}

class _PuzzleAppState extends State<PuzzleApp> {
  final _challengesBloc = ChallengesBloc();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PuzzleMath',
      navigatorKey: NavigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        ChallengeListScreen.routeName: (context) => BlocProvider.value(
              value: _challengesBloc,
              child: buildChallengeListScreen(context),
            ),
        CameraScreen.routeName: (context) => BlocProvider.value(
              value: _challengesBloc,
              child: buildCameraScreen(context),
            ),
        ChallengeScreen.routeName: (context) => BlocProvider.value(
              value: _challengesBloc,
              child: buildChallengeScreen(context),
            ),
        SolutionScreen.routeName: (context) => BlocProvider.value(
              value: _challengesBloc,
              child: buildSolutionScreen(context),
            ),
      },
    );
  }

  @override
  void dispose() {
    _challengesBloc.close();
    super.dispose();
  }
}
