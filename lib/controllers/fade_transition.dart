import 'package:flutter/material.dart';

class FadeTransitionRoute extends MaterialPageRoute {

  FadeTransitionRoute({WidgetBuilder builder, RouteSettings settings}): super(settings: settings, builder: builder);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    if (animation.status == AnimationStatus.reverse) {
      return super.buildTransitions(
        context,
        animation,
        secondaryAnimation,
        child,
      );
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
