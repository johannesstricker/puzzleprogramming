import 'package:flutter/material.dart';
import 'package:puzzlemath/screens/camera_screen.dart';
import 'package:puzzlemath/math/challenge.dart';

class ChallengeListItem extends StatelessWidget {
  final Challenge challenge;

  ChallengeListItem(this.challenge);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              CameraScreen.routeName,
              arguments: CameraScreenArguments(challenge: challenge),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(challenge.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(height: 4),
                    Text('Lorem ipsum dolor sit amit.',
                        style: TextStyle(color: Colors.black54)),
                  ],
                ),
                Icon(Icons.lock_open, color: Colors.black26),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
