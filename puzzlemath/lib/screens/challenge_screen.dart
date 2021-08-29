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

  Map<Marker, int> countAvailableMarkers() {
    final Map<Marker, int> markers = Map<Marker, int>();
    challenge.availableMarkers.forEach((marker) {
      markers[marker] = (markers[marker] ?? 0) + 1;
    });
    return markers;
  }

  Text buildTitle(BuildContext context) {
    return Text(challenge.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
        ));
  }

  Text buildDescription(BuildContext context) {
    return Text(challenge.description,
        style: TextStyle(
          color: Colors.black87,
        ));
  }

  Widget buildMarker(BuildContext context, Marker marker, int count) {
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
          Padding(
            padding: EdgeInsets.only(top: 1.0),
            child: Text('\u2715',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 10.0,
                )),
          ),
          SizedBox(width: 4.0),
          Text(count.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  Text buildSectionTitle(BuildContext context, String text) {
    return Text(text,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ));
  }

  Widget buildMarkerList(BuildContext context) {
    final availableMarkers = countAvailableMarkers();
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      childAspectRatio: 1.33,
      children: List.generate(
        availableMarkers.length,
        (index) {
          final marker = availableMarkers.entries.toList()[index];
          return buildMarker(context, marker.key, marker.value);
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
              buildTitle(context),
              SizedBox(height: 12.0),
              buildDescription(context),
              SizedBox(height: 24),
              buildSectionTitle(context, 'Use these puzzle pieces'),
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
