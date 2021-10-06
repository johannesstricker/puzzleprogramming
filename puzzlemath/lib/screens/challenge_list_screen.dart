import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzlemath/blocs/challenges/challenges.dart';
import 'package:puzzlemath/models/challenge/challenge.dart';
import 'package:puzzlemath/theme/colors.dart';
import 'package:puzzlemath/theme/typography.dart';
import 'package:puzzlemath/widgets/app_logo.dart';
import 'package:puzzlemath/widgets/challenge_list_item.dart';
import 'package:puzzlemath/widgets/progress_bar.dart';

class Carroussel extends StatefulWidget {
  final List<Challenge> challenges;

  Carroussel(this.challenges);

  @override
  _CarrousselState createState() => new _CarrousselState();
}

// TODO: using a PageView for this is not correct
//       this should be using a ListView with PageScrollPhysics
class _CarrousselState extends State<Carroussel> {
  late PageController controller;
  int currentPage = 0;
  int activeChallengeIndex = 0;
  final double viewportFraction = 0.85;

  @override
  initState() {
    super.initState();
    activeChallengeIndex = widget.challenges
        .indexWhere((challenge) => challenge.state == ChallengeState.Unlocked);
    currentPage = activeChallengeIndex;
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
          value = (1 - (tempValue.abs() * 0.2)).clamp(0.0, 1.0);
        }

        final viewportWidth = MediaQuery.of(context).size.width;
        return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Center(
            child: Transform.scale(
              scale: Curves.easeOut.transform(value),
              child: Container(
                width: viewportWidth,
                height: constraints.maxHeight,
                padding: EdgeInsets.only(bottom: 30),
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
        });
      },
      child: ChallengeListItem(widget.challenges[index], index: index + 1),
    );
  }
}

class ChallengeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}

class ChallengeListScreen extends StatelessWidget {
  static const routeName = '/';

  final int progress;

  ChallengeListScreen({this.progress = 0});

  Widget _wrapWithPadding(Widget child) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: child,
    );
  }

  Widget _buildHeading(BuildContext context) {
    bool hasMadeProgress = false;
    final state = BlocProvider.of<ChallengesBloc>(context).state;
    if (state is ChallengesLoaded) {
      hasMadeProgress = state.progress > 0;
    }
    final message = hasMadeProgress
        ? "you're making progress."
        : "ready for your first challenge?";
    return _wrapWithPadding(Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hey there,',
          style: TextHeadingAlt1,
        ),
        Text(
          message,
          style: TextHeadingAlt2,
        ),
      ],
    ));
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return _wrapWithPadding(Text(
      title,
      style: TextMediumM.copyWith(
        color: ColorPrimary,
      ),
    ));
  }

  Widget _buildAchievement(
      BuildContext context, String title, String description) {
    return _wrapWithPadding(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            color: ColorNeutral40,
          ),
          SizedBox(width: 8.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextMediumM,
              ),
              Text(
                description,
                style: TextRegularS.copyWith(color: ColorNeutral70),
              ),
            ],
          ),
        ]));
  }

  Widget _buildProgressBar(BuildContext context) {
    return BlocBuilder<ChallengesBloc, ChallengesState>(
      builder: (context, state) {
        double progress = 0;
        if (state is ChallengesLoaded) {
          progress = state.progress;
        }
        return _wrapWithPadding(ProgressBar(progress: progress));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32.0),
            Center(child: AppLogo()),
            SizedBox(height: 24.0),
            _buildHeading(context),
            SizedBox(height: 8.0),
            _buildProgressBar(context),
            SizedBox(height: 12.0),
            _buildSectionTitle(context, 'Latest Achievement'),
            SizedBox(height: 8.0),
            _buildAchievement(context, 'Multiplication Master',
                'Multiply three numbers at once.'),
            SizedBox(height: 24.0),
            _buildSectionTitle(context, 'Challenges'),
            SizedBox(height: 8.0),
            Container(
              height: 400,
              child: ChallengeList(),
            ),
          ],
        ),
      ),
    );
  }
}
