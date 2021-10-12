import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> NavigatorKey = new GlobalKey<NavigatorState>();

class FadingPageRoute extends PageRouteBuilder {
  FadingPageRoute(Widget page) : super(pageBuilder: (_, __, ___) => page);

  @override
  Widget buildTransitions(_, animation, __, child) {
    return FadeTransition(opacity: animation, child: child);
  }
}
