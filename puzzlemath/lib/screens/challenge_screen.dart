import 'package:flutter/material.dart';
import 'package:puzzlemath/screens/camera_screen.dart';
import 'package:puzzlemath/math/challenge.dart';

class ChallengeScreenArguments {
  final Challenge challenge;

  ChallengeScreenArguments({required this.challenge});
}

class ChallengeScreen extends StatelessWidget {
  static const routeName = '/challenge';

  final Challenge challenge;

  ChallengeScreen(ChallengeScreenArguments args) : challenge = args.challenge;

  Widget buildHeader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(challenge.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            )),
        SizedBox(height: 12),
        Text(challenge.description),
      ],
    );
  }

  Widget buildMarker(BuildContext context) {
    return Expanded(
      child: const DecoratedBox(
        decoration: const BoxDecoration(color: Colors.red),
      ),
    );
  }

  Widget buildMarkerList(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      children: List.generate(
        challenge.availableMarkers?.length ?? 0,
        (index) => buildMarker(context),
      ),
    );
  }

  Widget buildMainWidget(BuildContext context) {
    return Container(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(context),
              SizedBox(height: 24),
              Text('Use these puzzle pieces',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 12),
              buildMarkerList(context),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => navigateToCameraScreen(context),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                    child: Text('Ready'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToCameraScreen(BuildContext context) {
    Navigator.pushNamed(
      context,
      CameraScreen.routeName,
      arguments: CameraScreenArguments(challenge: challenge),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Puzzle Programming'),
        centerTitle: true,
      ),
      body: buildMainWidget(context),
    );
  }
}
