import 'package:flutter/material.dart';
import 'package:puzzlemath/theme/theme.dart';

class ProgressBar extends StatelessWidget {
  final double progress;
  final Color background;
  final Color foreground;

  ProgressBar({
    required this.progress,
    this.background = ColorPrimarySurface,
    this.foreground = ColorPrimary,
  });

  Widget _buildProgressBar(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: _buildRoundedDecoration(background),
        height: 8,
        child: FractionallySizedBox(
          widthFactor: progress,
          heightFactor: 1.0,
          child: Container(
            decoration: _buildRoundedDecoration(foreground),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildRoundedDecoration(Color backgroundColor) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    );
  }

  Widget _buildProgressText(BuildContext context) {
    return Text(
      '${(progress * 100).round()} %',
      style: TextHeadingAlt2.copyWith(color: foreground),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProgressBar(context),
          SizedBox(width: 16.0),
          _buildProgressText(context),
        ],
      ),
    );
  }
}
