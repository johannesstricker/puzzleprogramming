import 'package:flutter/animation.dart';
import 'dart:math';

class SineCurve extends Curve {
  final double count;

  SineCurve({this.count = 3});

  @override
  double transformInternal(double t) {
    return sin(count * 2 * pi * t);
  }
}
