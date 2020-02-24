import 'package:flutter/material.dart';

class ColorTransitionBox extends AnimatedWidget{

  final Widget child;
  ColorTransitionBox({Key key, Animation<Color> animation, this.child}): super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {

    Animation<Color> animation = listenable;

    return DecoratedBox(
      decoration: BoxDecoration(color: animation.value),
      child: this.child,
    );
  }
}