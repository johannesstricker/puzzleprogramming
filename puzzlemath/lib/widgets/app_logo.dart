import 'package:flutter/material.dart';
import 'package:puzzlemath/theme/theme.dart';

class AppLogo extends StatelessWidget {
  Widget _buildDecoration(BuildContext context,
      {required double width, required double height}) {
    return Transform.translate(
      offset: Offset(0, 4),
      child: Transform(
        transform: Matrix4.skew(0.1, -0.03),
        child: Container(
          width: width,
          height: height,
          color: ColorSecondary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 95,
      child: Transform.rotate(
        angle: -0.05,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            FractionallySizedBox(
                widthFactor: 1.05,
                heightFactor: 0.55,
                child: _buildDecoration(context,
                    width: double.infinity, height: double.infinity)),
            Text(
              'MAZZLE',
              style: TextHeading1.copyWith(color: ColorPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
