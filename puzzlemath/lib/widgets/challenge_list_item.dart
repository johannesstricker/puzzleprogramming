import 'package:flutter/material.dart';
import 'package:puzzlemath/screens/challenge_screen.dart';
import 'package:puzzlemath/math/challenge.dart';

class ChallengeListItem extends StatelessWidget {
  final Challenge challenge;
  final ChallengeState state;

  ChallengeListItem(this.challenge, {this.state = ChallengeState.Locked});

  Icon buildIcon() {
    if (state == ChallengeState.Solved) {
      return Icon(Icons.done, color: Colors.green);
    } else if (state == ChallengeState.Unlocked) {
      return Icon(Icons.lock_open, color: Colors.black54);
    }
    return Icon(Icons.lock_outline, color: Colors.black26);
  }

  Text buildTitle() {
    return Text(challenge.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: state == ChallengeState.Locked ? Colors.black26 : Colors.black,
        ));
  }

  Text buildDescription() {
    return Text('Lorem ipsum dolor sit amit.',
        style: TextStyle(
          color:
              state == ChallengeState.Locked ? Colors.black26 : Colors.black54,
        ));
  }

  Widget buildRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTitle(),
              SizedBox(height: 4),
              buildDescription(),
            ],
          ),
          buildIcon(),
        ],
      ),
    );
  }

  void navigateToChallenge(BuildContext context) {
    Navigator.pushNamed(
      context,
      ChallengeScreen.routeName,
      arguments: ChallengeScreenArguments(challenge: challenge),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.white,
        child: state == ChallengeState.Locked
            ? buildRow()
            : InkWell(
                onTap: () => navigateToChallenge(context),
                child: buildRow(),
              ),
      ),
    );
  }
}
