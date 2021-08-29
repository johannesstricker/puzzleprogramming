import 'package:flutter/material.dart';
import 'screens/camera_screen.dart';
import 'screens/home_screen.dart';
import 'screens/challenge_list_screen.dart';
import 'screens/challenge_screen.dart';

void main() {
  runApp(CameraApp());
}

ChallengeListScreen navigateToChallengeListScreen(context) {
  return ChallengeListScreen();
}

CameraScreen navigateToCameraScreen(context) {
  final args =
      ModalRoute.of(context)!.settings.arguments as CameraScreenArguments;
  return CameraScreen(args);
}

ChallengeScreen navigateToChallengeScreen(context) {
  final args =
      ModalRoute.of(context)!.settings.arguments as ChallengeScreenArguments;
  return ChallengeScreen(args);
}

class CameraApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': navigateToChallengeListScreen,
        CameraScreen.routeName: navigateToCameraScreen,
        ChallengeScreen.routeName: navigateToChallengeScreen,
      },
    );
  }
}
