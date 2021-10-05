import 'package:flutter/material.dart';
import 'package:puzzlemath/widgets/button.dart';

class PuzzleAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  PuzzleAppBar()
      : preferredSize = Size.fromHeight(64.0),
        super();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.0,
        right: 8.0,
        bottom: 8.0,
        left: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Button.Light(
              icon: Icons.navigate_before,
              onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
