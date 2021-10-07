import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:puzzlemath/math/math.dart';
import 'package:puzzlemath/theme/theme.dart';

double degreesToRadians(double degrees) {
  return degrees * math.pi / 180.0;
}

class PuzzlePiece extends StatelessWidget {
  final double width;
  final double height;
  final Marker _marker;

  PuzzlePiece(this._marker, {required this.width, required this.height});

  Color _backgroundColor() {
    if (isDigitMarker(this._marker)) {
      return ColorDigit;
    }
    if (isOperatorMarker(this._marker)) {
      return ColorOperator;
    }
    return ColorNeutral40;
  }

  String _markerString() {
    if (isDigitMarker(this._marker)) {
      return this._marker.index.toString();
    }
    switch (this._marker) {
      case Marker.OperatorAdd:
        return '+';
      case Marker.OperatorDivide:
        return '/';
      case Marker.OperatorMultiply:
        return '*';
      case Marker.OperatorSubtract:
        return '-';
      case Marker.Start:
        return 'S';
      case Marker.End:
        return 'E';
      default:
        return '?';
    }
  }

  Widget _text() {
    return FittedBox(
      fit: BoxFit.contain,
      child: Text(
        _markerString(),
        style: TextHeading2.copyWith(color: ColorNeutral10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: degreesToRadians(2),
      child: Container(
        width: width,
        height: height,
        color: _backgroundColor(),
        child: Center(
          child: _text(),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Image.asset('assets/images/${_marker.toString()}.png');
  // }
}
