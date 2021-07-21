import 'package:flutter/material.dart';
import 'screens/camera_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(CameraApp());
}

HomeScreen navigateToHomeScreen(context) {
  return HomeScreen();
}

CameraScreen navigateToCameraScreen(context) {
  return CameraScreen();
}

// FinalScreen navigateToFinalScreen(context) {
//   final args =
//       ModalRoute.of(context)!.settings.arguments as FinalScreenArguments;
//   return FinalScreen(args.message);
// }

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
        '/': navigateToHomeScreen,
        '/camera': navigateToCameraScreen,
      },
    );
  }
}