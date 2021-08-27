import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../math/challenge.dart';
import '../math/math.dart';
import './camera_screen.dart';

class ChallengeListScreen extends StatelessWidget {
  final List<Challenge> challenges;

  ChallengeListScreen()
      : challenges = [
          Challenge(
              name: "What's the magic number?",
              solution: 1337,
              availableMarkers: [
                Marker.Digit1,
                Marker.Digit3,
                Marker.Digit3,
                Marker.Digit7
              ]),
          Challenge(name: "Child's play.", solution: 2, availableMarkers: [
            Marker.Digit1,
            Marker.Digit1,
            Marker.OperatorAdd
          ]),
          Challenge(
              name: 'Easy peasy, lemon squeezy!',
              solution: 28,
              availableMarkers: [
                Marker.Digit2,
                Marker.Digit0,
                Marker.OperatorAdd,
                Marker.Digit1,
                Marker.Digit2,
                Marker.OperatorSubtract,
                Marker.Digit4
              ]),
          Challenge(
              name: "Let's turn these numbers up!",
              solution: 999,
              availableMarkers: [
                Marker.Digit3,
                Marker.Digit3,
                Marker.Digit3,
                Marker.Digit3,
                Marker.OperatorMultiply,
              ]),
        ];

  Widget buildChallengeItem(BuildContext context, int index) {
    final Challenge challenge = challenges[index];
    return Container(
      // color: Colors.white,
      child: InkWell(
        onTap: () {
          debugPrint(challenge.name);
          Navigator.pushNamed(
            context,
            CameraScreen.routeName,
            arguments: CameraScreenArguments(challenge: challenge),
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(challenge.name),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Puzzle Programming'),
          centerTitle: true,
        ),
        body: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            thickness: 2.0,
            height: 2.0,
            color: Colors.white,
          ),
          itemCount: challenges.length,
          itemBuilder: buildChallengeItem,
        ));
  }
}
