import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

abstract class AnimationControllerState<T extends StatefulWidget>
    extends State<T> with SingleTickerProviderStateMixin {
  final Duration animationDuration;
  late final animationController = AnimationController(
    vsync: this,
    duration: animationDuration,
  );

  AnimationControllerState(this.animationDuration);

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
