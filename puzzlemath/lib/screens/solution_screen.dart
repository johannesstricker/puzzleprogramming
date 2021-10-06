import 'package:flutter/material.dart';
import 'package:puzzlemath/models/challenge/challenge.dart';
import 'package:puzzlemath/math/math.dart';
import 'package:puzzlemath/screens/challenge_list_screen.dart';
import 'package:puzzlemath/widgets/app_bar.dart';
import 'package:puzzlemath/widgets/puzzle_piece.dart';
import 'package:puzzlemath/widgets/button.dart';
import 'package:puzzlemath/theme/theme.dart';

class SolutionScreenArguments {
  final int proposedSolution;
  final List<Marker> usedMarkers;
  final Challenge challenge;

  SolutionScreenArguments({
    required this.proposedSolution,
    required this.usedMarkers,
    required this.challenge,
  });
}

class SolutionScreen extends StatelessWidget {
  static const routeName = '/solution';

  final int proposedSolution;
  final List<Marker> usedMarkers;
  final Challenge challenge;
  final bool isCorrect;

  SolutionScreen(SolutionScreenArguments args)
      : proposedSolution = args.proposedSolution,
        usedMarkers = args.usedMarkers,
        challenge = args.challenge,
        isCorrect = args.challenge
            .checkSolution(args.proposedSolution, args.usedMarkers);

  int countOccurences(List<Marker> haystack, Marker needle) {
    return haystack.where((marker) => marker == needle).length;
  }

  Text buildTitle(BuildContext context) {
    return Text(
      challenge.name,
      style: TextHeading1,
    );
  }

  Text buildDescription(BuildContext context) {
    return Text(
      challenge.description,
      style: TextRegularM.copyWith(color: ColorNeutral70),
    );
  }

  Widget buildSuccessButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Button.Primary(
        text: 'Continue',
        icon: Icons.check,
        onPressed: () {
          Navigator.pushNamed(
            context,
            ChallengeListScreen.routeName,
          );
        },
      ),
    );
  }

  Widget buildRetryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Button.Primary(
        text: 'Try again',
        icon: Icons.replay,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
              context, ChallengeListScreen.routeName, (route) => false);
        },
        style: TextButton.styleFrom(
          primary: Colors.black54,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Text('Return to home screen'),
        ),
      ),
    );
  }

  Widget buildSolutionWidget() {
    final foregroundColor = isCorrect ? Colors.green : Colors.red;
    return Text(
      proposedSolution.toString(),
      style: TextHeading1.copyWith(
        color: foregroundColor,
        fontSize: 48.0,
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
              SizedBox(height: 4.0),
              buildDescription(context),
              SizedBox(height: 24),
              buildSectionTitle('Used puzzle pieces'),
              buildMarkerList(context),
              SizedBox(height: 24),
              buildSectionTitle('Your solution'),
              buildSolutionWidget(),
              SizedBox(height: 24),
              isCorrect
                  ? buildSuccessButton(context)
                  : buildRetryButton(context),
              SizedBox(height: 4),
              isCorrect ? Container() : buildCancelButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMarker(Marker marker, int used, int available) {
    final Color textColor = used == available ? Colors.green : Colors.red;
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
                  color: textColor,
                  fontSize: 10.0,
                )),
          ),
          SizedBox(width: 2.0),
          Text(used.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: textColor,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  Widget buildMarkerList(BuildContext context) {
    final allMarkers =
        (challenge.availableMarkers + usedMarkers).toSet().toList();
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 4.0,
      childAspectRatio: 1.33,
      children: List.generate(
        allMarkers.length,
        (index) {
          final marker = allMarkers[index];
          final useCount = countOccurences(usedMarkers, marker);
          final availableCount =
              countOccurences(challenge.availableMarkers, marker);
          return buildMarker(marker, useCount, availableCount);
        },
      ),
    );
  }

  Text buildSectionTitle(String text) {
    return Text(
      text,
      style: TextMediumM.copyWith(color: ColorPrimary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PuzzleAppBar(showBackButton: false),
      body: buildMainWidget(context),
    );
  }
}
