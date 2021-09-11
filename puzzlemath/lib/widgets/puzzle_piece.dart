import 'package:flutter/material.dart';
import 'package:puzzlemath/math/math.dart';

class PuzzlePiece extends StatelessWidget {
  final Marker _marker;

  PuzzlePiece(this._marker);

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/${_marker.toString()}.png');
  }
}
