import 'package:flutter/material.dart';
import 'package:puzzlemath/math/math.dart';
import 'package:puzzlemath/theme/theme.dart';
import 'package:puzzlemath/widgets/puzzle_piece.dart';

class Equation extends StatelessWidget {
  final double itemWidth, itemHeight, spaceBetween;
  final int solution;
  final List<Marker> markers;

  Equation(
      {required this.markers,
      required this.solution,
      this.itemWidth = 32,
      this.itemHeight = 32,
      this.spaceBetween = 2});

  List<Widget> _joinWidgets(List<Widget> widgets, Widget separator) {
    final iterator = widgets.iterator;
    if (!iterator.moveNext()) return [];
    final result = [iterator.current];
    while (iterator.moveNext()) {
      result..add(separator)..add(iterator.current);
    }
    return result;
  }

  List<Widget> _buildChildren(BuildContext context) {
    final markerWidgets = markers.map((marker) => Flexible(
        child: PuzzlePiece(marker, width: itemHeight, height: itemHeight)));
    final text = FittedBox(
        fit: BoxFit.contain,
        child: Text(' = $solution',
            style: TextHeading1.copyWith(color: ColorNeutral10)));
    return _joinWidgets(
        [...markerWidgets, text], SizedBox(width: spaceBetween));
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(height: itemHeight),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _buildChildren(context),
      ),
    );
  }
}
