import 'package:flutter/material.dart';

class ColorTransitionText extends AnimatedWidget{

  final String text;
  final TextStyle style;
  ColorTransitionText({Key key, Animation<Color> animation, this.text, this.style}): super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {

    Animation<Color> animation = listenable;
    return Text(
      text,
      style: this.style.copyWith(color: animation.value),
    );
  }
}

class ColorTransitionIcon extends AnimatedWidget{

  final IconData iconData;
  ColorTransitionIcon({Key key, Animation<Color> animation, this.iconData}): super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {

    Animation<Color> animation = listenable;
    return Icon(iconData,color: animation.value,);
  }

}