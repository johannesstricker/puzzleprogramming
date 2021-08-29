import 'package:flutter/material.dart';
import 'package:puzzlemath/math/challenge.dart';
import 'package:puzzlemath/math/math.dart';
import 'package:puzzlemath/screens/challenge_list_screen.dart';

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

  Color backgroundColor() {
    return isCorrect ? Colors.greenAccent : Colors.redAccent;
  }

  Color textColor() {
    return Colors.white;
  }

  Widget buildSuccessButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            ChallengeListScreen.routeName,
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Text('Return'),
        ),
      ),
    );
  }

  Widget buildRetryButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Text('Retry'),
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text('Puzzle Programming'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
        color: backgroundColor(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Center(
                child: Text(proposedSolution.toString(),
                    style: TextStyle(
                      color: textColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: 42.0,
                    )),
              ),
            ),
            isCorrect ? buildSuccessButton(context) : buildRetryButton(context),
            isCorrect ? SizedBox(height: 0) : buildCancelButton(context),
          ],
        ),
      ),
    );
  }
}
