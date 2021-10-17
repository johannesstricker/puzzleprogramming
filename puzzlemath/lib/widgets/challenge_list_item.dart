import 'package:flutter/material.dart';
import 'package:puzzlemath/config/navigation.dart';
import 'package:puzzlemath/screens/challenge_screen.dart';
import 'package:puzzlemath/models/challenge/challenge.dart';
import 'package:puzzlemath/widgets/button.dart';
import 'package:puzzlemath/theme/theme.dart';
import 'package:puzzlemath/widgets/text_marker.dart';

class ChallengeListItem extends StatelessWidget {
  final int index;
  final Challenge challenge;

  ChallengeListItem(this.challenge, {required this.index});

  Widget buildAnchor() {
    return Text(
      index.toString().padLeft(2, '0'),
      style: TextRegularS.copyWith(
        color: challenge.state == ChallengeState.Unlocked
            ? ColorPrimarySurface
            : ColorNeutral60,
      ),
    );
  }

  Widget buildTitle() {
    return Hero(
      tag: '${challenge.id}-title',
      child: TextMarker(
        color: challenge.state == ChallengeState.Locked
            ? ColorNeutral40
            : ColorSecondary,
        child: Material(
          color: Colors.transparent,
          child: Text(
            challenge.name,
            style: TextHeading1.copyWith(
              color: challenge.state == ChallengeState.Unlocked
                  ? ColorNeutral10
                  : ColorNeutral100,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDescription() {
    return Hero(
      tag: '${challenge.id}-description',
      child: Material(
        color: Colors.transparent,
        child: Text(
          challenge.description,
          style: TextRegularM.copyWith(
            color: challenge.state == ChallengeState.Unlocked
                ? ColorPrimarySurface
                : ColorNeutral60,
          ),
        ),
      ),
    );
  }

  String? _buttonText() {
    if (challenge.state == ChallengeState.Locked) {
      return 'Locked';
    }
    return challenge.state == ChallengeState.Solved ? 'Play again' : 'Continue';
  }

  IconData? _buttonIcon() {
    if (challenge.state == ChallengeState.Unlocked) {
      return null;
    }
    return challenge.state == ChallengeState.Locked ? Icons.lock : Icons.replay;
  }

  Widget buildRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildAnchor(),
          SizedBox(height: 12),
          buildTitle(),
          SizedBox(height: 20),
          buildDescription(),
          Spacer(flex: 1),
          Hero(
            tag: '${challenge.id}-button',
            child: Button(
              text: _buttonText(),
              variant: challenge.state == ChallengeState.Unlocked
                  ? ButtonVariant.light
                  : ButtonVariant.primary,
              icon: _buttonIcon(),
              enabled: challenge.state != ChallengeState.Locked,
              onPressed: () => navigateToChallenge(context),
            ),
          ),
        ],
      ),
    );
  }

  void navigateToChallenge(BuildContext context) {
    final args = ChallengeScreenArguments(challenge: challenge);
    Navigator.of(context).push(FadingPageRoute(ChallengeScreen(args)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: challenge.state == ChallengeState.Unlocked
            ? ColorPrimary
            : ColorNeutral10,
        child: buildRow(context),
      ),
    );
  }
}
