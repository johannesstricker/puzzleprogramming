import 'package:flutter/material.dart';
import 'package:puzzlemath/screens/camera_screen.dart';
import 'package:puzzlemath/models/challenge/challenge.dart';
import 'package:puzzlemath/math/math.dart';
import 'package:puzzlemath/theme/theme.dart';
import 'package:puzzlemath/widgets/app_bar.dart';
import 'package:puzzlemath/widgets/puzzle_piece.dart';
import 'package:puzzlemath/widgets/button.dart';
import 'package:puzzlemath/widgets/text_marker.dart';

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

  Widget buildTitle(BuildContext context) {
    return Hero(
      tag: '${challenge.id}-title',
      child: TextMarker(
        child: Material(
          color: Colors.transparent,
          child: Text(
            challenge.name,
            style: TextHeading1,
          ),
        ),
      ),
    );
  }

  Widget buildDescription(BuildContext context) {
    return Hero(
      tag: '${challenge.id}-description',
      child: Material(
        color: Colors.transparent,
        child: Text(
          challenge.description,
          style: TextRegularM.copyWith(color: ColorNeutral70),
        ),
      ),
    );
  }

  Widget buildMarker(BuildContext context, Marker marker, int count) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PuzzlePiece(marker, width: 32, height: 32),
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
          SizedBox(width: 2.0),
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
    return Text(
      text,
      style: TextMediumM.copyWith(color: ColorPrimary),
    );
  }

  Widget buildMarkerList(BuildContext context) {
    final availableMarkers = countAvailableMarkers().entries.toList();
    availableMarkers.sort((a, b) => a.key.index.compareTo(b.key.index));
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 4.0,
      childAspectRatio: 1.33,
      children: List.generate(
        availableMarkers.length,
        (index) {
          final marker = availableMarkers[index];
          return buildMarker(context, marker.key, marker.value);
        },
      ),
    );
  }

  Widget buildMainWidget(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTitle(context),
                  SizedBox(height: 4),
                  buildDescription(context),
                  SizedBox(height: 24),
                  buildSectionTitle(context, 'Use these puzzle pieces'),
                  buildMarkerList(context),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Hero(
                tag: '${challenge.id}-button',
                child: Button.Primary(
                  text: 'Ready',
                  onPressed: () => navigateToCameraScreen(context),
                ),
              ),
            ),
          ),
        ),
      ],
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
      // appBar: PuzzleAppBar(),
      appBar: PuzzleAppBar(),
      body: buildMainWidget(context),
    );
  }
}
