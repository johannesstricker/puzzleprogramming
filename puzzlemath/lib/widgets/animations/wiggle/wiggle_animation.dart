import 'package:flutter/material.dart';
import 'package:puzzlemath/widgets/animations/wiggle/sine_curve.dart';
import 'package:puzzlemath/widgets/animations/wiggle/animation_controller_state.dart';

class WiggleAnimation extends StatefulWidget {
  final Widget child;
  final double shakeOffset;
  final int shakeCount;
  final Duration shakeDuration;

  const WiggleAnimation({
    Key? key,
    required this.child,
    required this.shakeOffset,
    this.shakeCount = 3,
    this.shakeDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  WiggleAnimationState createState() => WiggleAnimationState(shakeDuration);
}

class WiggleAnimationState extends AnimationControllerState<WiggleAnimation> {
  late Animation<double> _sineAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: animationController,
          curve: SineCurve(count: widget.shakeCount.toDouble())));

  WiggleAnimationState(Duration duration) : super(duration);

  @override
  void initState() {
    super.initState();
    animationController.addStatusListener(_updateStatus);
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_updateStatus);
    super.dispose();
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      animationController.reset();
    }
  }

  void wiggle() {
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _sineAnimation,
        child: widget.child,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_sineAnimation.value * widget.shakeOffset, 0),
            child: child,
          );
        });
  }
}
