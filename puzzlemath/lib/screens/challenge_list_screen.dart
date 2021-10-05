import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzlemath/blocs/challenges/challenges.dart';
import 'package:puzzlemath/models/challenge/challenge.dart';
import 'package:puzzlemath/theme/colors.dart';
import 'package:puzzlemath/widgets/challenge_list_item.dart';

class Carroussel extends StatefulWidget {
  final List<Challenge> challenges;

  Carroussel(this.challenges);

  @override
  _CarrousselState createState() => new _CarrousselState();
}

class _CarrousselState extends State<Carroussel> {
  late PageController controller;
  int currentPage = 2;
  final double viewportFraction = 0.88;

  @override
  initState() {
    super.initState();
    controller = PageController(
      initialPage: currentPage,
      keepPage: false,
      viewportFraction: viewportFraction,
    );
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView.builder(
        onPageChanged: (value) {
          setState(() {
            currentPage = value;
          });
        },
        controller: controller,
        itemCount: widget.challenges.length,
        itemBuilder: (context, index) => _builder(index),
      ),
    );
  }

  _builder(int index) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double value = 1.0;
        if (controller.position.haveDimensions) {
          double tempValue = controller.page! - index;
          value = (1 - (tempValue.abs() * 0.3)).clamp(0.0, 1.0);
        }

        final viewportWidth = MediaQuery.of(context).size.width;
        return Center(
          child: SizedBox(
            width: Curves.easeOut.transform(value) * viewportWidth,
            height: Curves.easeOut.transform(value) * viewportWidth,
            child: Container(
              margin: const EdgeInsets.all(2.0),
              child: Card(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                elevation: Curves.easeOut.transform(value) * 12,
                shadowColor: ColorNeutral20,
                child: child,
              ),
            ),
          ),
        );
      },
      child: ChallengeListItem(widget.challenges[index]),
    );
  }
}

class ChallengeListScreen extends StatelessWidget {
  static const routeName = '/';

  final int progress;

  ChallengeListScreen({this.progress = 0});

  Widget buildChallengeItem(List<Challenge> challenges, int index) {
    final Challenge challenge = challenges[index];
    return ChallengeListItem(challenge);
  }

  Widget buildBody(BuildContext context) {
    return BlocBuilder<ChallengesBloc, ChallengesState>(
      builder: (context, state) {
        if (state is ChallengesLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is ChallengesError) {
          return Center(child: Text('An error occured.'));
        }
        final List<Challenge> challenges =
            (state as ChallengesLoaded).challenges;
        return Carroussel(challenges);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: buildBody(context),
    );
  }
}
