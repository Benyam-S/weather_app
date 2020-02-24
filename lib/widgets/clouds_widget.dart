import 'package:flutter/material.dart';

class Clouds extends AnimatedWidget{

  final bool isRaining;
  Clouds({Key key,Animation<Color> animation, this.isRaining}): super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {

    final Animation<Color> animation = listenable;
    Size screenSize = MediaQuery.of(context).size;
    Paint _paintBrush = Paint()
      ..color = animation.value
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;


    return Container(
      child: CustomPaint(
        size: screenSize,
        painter: CloudPainter(
          painterBrush: _paintBrush,
          isRaining: isRaining,
        ),
      ),
    );
  }
}


class CloudPainter extends CustomPainter{

  final Paint painterBrush;
  final bool isRaining;

  CloudPainter({this.painterBrush, this.isRaining});

  @override
  void paint(Canvas canvas, Size size) {

    double top = 200;
    double bottom = top + 40;
    double left = size.width / 4;
    double right = size.width - 90;
    double center = size.width/2;


    Rect rect = Rect.fromPoints(
    Offset(left + 10,top),
    Offset(right,bottom),
    );

    RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(10));

    canvas.drawCircle(Offset(left + 20,190), 50, painterBrush);
    canvas.drawCircle(Offset(center + 10,160), 60, painterBrush);
    canvas.drawCircle(Offset(right,160), 80, painterBrush);

    painterBrush.strokeWidth = 3.0;
    canvas.drawRRect(rRect, painterBrush);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}