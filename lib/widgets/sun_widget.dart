import 'package:flutter/material.dart';

class Sun extends AnimatedWidget{

  Sun({Key key, Animation<Color> animation}): super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context){

    Animation<Color> animation = listenable;

    Size screenSize = MediaQuery.of(context).size;
    Paint paintBrush = Paint()
    ..color = animation.value
    ..strokeWidth = 3.0
    ..strokeCap = StrokeCap.round;

    return Container(
      child: CustomPaint(
        size: screenSize,
        painter: SunPainter(
          brush: paintBrush,
        ),
      ),
    );
  }

}

class SunPainter extends CustomPainter{

  final Paint brush;

  SunPainter({this.brush});

  @override
  void paint(Canvas canvas, Size size){

    double centerWidth = size.width/2;

    canvas.drawCircle(Offset(centerWidth,110), 100, brush);
  }

  bool shouldRepaint(CustomPainter customPainter){
    return false;
  }

}