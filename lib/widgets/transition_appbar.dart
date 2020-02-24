import 'package:flutter/material.dart';

class TransitionAppbar extends AnimatedWidget{

  final Widget title;
  final List<Widget> actionIcon;
  final Widget leading;

  TransitionAppbar({Key key, this.title, this.actionIcon, this.leading, Animation<Color> animation}) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {

    Animation<Color> animation = listenable;

    return AppBar(
      backgroundColor: animation.value,
      leading: this.leading,
      title: title,
      actions: actionIcon,
    );

  }

}
