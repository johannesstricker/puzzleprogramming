import 'package:flutter/material.dart';
import 'package:puzzlemath/screens/challenge_screen.dart';
import 'package:puzzlemath/models/challenge/challenge.dart';
import 'package:puzzlemath/widgets/button.dart';
import 'package:puzzlemath/theme/theme.dart';

class ChallengeListItem extends StatelessWidget {
  final Challenge challenge;

  ChallengeListItem(this.challenge);

  Icon buildIcon() {
    if (challenge.state == ChallengeState.Solved) {
      return Icon(Icons.done, color: Colors.green);
    } else if (challenge.state == ChallengeState.Unlocked) {
      return Icon(Icons.lock_open, color: Colors.black54);
    }
    return Icon(Icons.lock_outline, color: Colors.black26);
  }

  Text buildTitle() {
    return Text(
      challenge.name,
      style: TextHeading1,
    );
  }

  Text buildDescription() {
    return Text(
      challenge.description,
      style: TextRegularM.copyWith(
        color: ColorNeutral60,
      ),
    );
  }

  Widget buildRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildTitle(),
          SizedBox(height: 4),
          buildDescription(),
          Spacer(flex: 1),
          Button.Primary(
            text: 'Continue',
            icon: challenge.state == ChallengeState.Locked ? Icons.lock : null,
            enabled: challenge.state != ChallengeState.Locked,
            onPressed: () => navigateToChallenge(context),
          ),
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
        child: buildRow(context),
      ),
    );
  }
}
