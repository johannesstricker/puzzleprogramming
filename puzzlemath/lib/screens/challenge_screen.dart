import 'package:flutter/material.dart';
import 'package:puzzlemath/screens/camera_screen.dart';
import 'package:puzzlemath/math/challenge.dart';
import 'package:puzzlemath/math/math.dart';

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

  Widget buildMarker(BuildContext context, Marker marker) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.05),
        borderRadius: BorderRadius.circular(3.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/${marker.toString()}.png'),
          SizedBox(width: 4.0),
          Text('\u2715',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.0,
              )),
          SizedBox(width: 2.0),
          Text('10',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  Widget buildMarkerList(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      childAspectRatio: 1.33,
      children: List.generate(
        challenge.availableMarkers.length,
        (index) {
          final marker = challenge.availableMarkers[index];
          return buildMarker(context, marker);
        },
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
