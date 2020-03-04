import 'package:flutter/material.dart';

class TemperatureUnitSelectors extends StatelessWidget{
  final bool isSelected;
  final String name;
  final Function onSelect;
  Color textColor = Colors.black;
  Color backgroundColor = Colors.white;

  TemperatureUnitSelectors({Key key, this.isSelected, this.name, this.onSelect}): super(key: key);

  @override
  Widget build(BuildContext context) {

    if (isSelected){
      textColor = Colors.white;
      backgroundColor = Colors.black;
    }
    return Expanded(
      child: GestureDetector(
        onTap: onSelect,
        child: Container(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            child: Center(child: Text(name, style: TextStyle(color: textColor),))
        ),
      ),
    );
  }

}