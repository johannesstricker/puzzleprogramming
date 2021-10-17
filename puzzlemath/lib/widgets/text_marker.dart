import 'package:flutter/material.dart';
import 'package:puzzlemath/theme/colors.dart';

class TextMarker extends StatelessWidget {
  final Color color;
  final Widget child;

  TextMarker({required this.child, this.color = ColorSecondary});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Transform.translate(
          offset: Offset(-3.0, 2.0),
          child: Transform.rotate(
            angle: -0.05,
            child: Container(
              width: 40,
              height: 15,
              color: this.color,
            ),
          ),
        ),
        this.child,
      ],
    );
  }
}
