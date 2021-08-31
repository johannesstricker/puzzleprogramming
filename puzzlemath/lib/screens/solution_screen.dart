import 'package:flutter/material.dart';
import 'package:puzzlemath/math/challenge.dart';
import 'package:puzzlemath/math/math.dart';
import 'package:puzzlemath/screens/challenge_list_screen.dart';
import 'package:puzzlemath/widgets/puzzle_piece.dart';

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.check),
              SizedBox(width: 4),
              Text('Continue'),
            ],
          ),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.refresh),
              SizedBox(width: 4),
              Text('Try again'),
            ],
          ),
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

  Widget buildSolutionWidget() {
    final backgroundColor = isCorrect
        ? Color.fromRGBO(0, 155, 0, 0.1)
        : Color.fromRGBO(155, 0, 0, 0.1);
    final foregroundColor = isCorrect ? Colors.green : Colors.red;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(3.0),
        border: Border.all(width: 2, color: foregroundColor),
      ),
      child: Text(
        proposedSolution.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 42.0,
          fontWeight: FontWeight.bold,
          color: foregroundColor,
        ),
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
              SizedBox(height: 8),
              buildDescription(context),
              SizedBox(height: 24),
              buildSectionTitle('Used puzzle pieces'),
              SizedBox(height: 8),
              buildMarkerList(context),
              SizedBox(height: 24),
              buildSectionTitle('Your solution'),
              SizedBox(height: 8),
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
      decoration: BoxDecoration(
        // color: Color.fromRGBO(0, 0, 0, 0.05),
        color: Color.fromRGBO(0, 155, 0, 0.1),
        borderRadius: BorderRadius.circular(3.0),
        border: Border.all(width: 2, color: textColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PuzzlePiece(marker),
          SizedBox(width: 8.0),
          Text('$used/$available',
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
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
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
    return Text(text,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text('Puzzle Programming'),
        centerTitle: true,
      ),
      body: buildMainWidget(context),
    );
  }
}
