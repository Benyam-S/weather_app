import 'package:flutter/material.dart';
import 'package:weather_app/models/src/countries.dart';
import 'package:weather_app/models/src/weather_data.dart';
import 'package:weather_app/widgets/temperature_unit_selectors.dart';

import '../main.dart';

class SettingsPage extends StatefulWidget {
  final TemperatureUnit selectedUnit;
  SettingsPage({Key key, this.selectedUnit}) : super(key: key);

  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TemperatureUnit selectedUnit;
  bool celsiusSelected = false;
  bool fahrenheitSelected = false;

  @override
  void initState() {
    super.initState();
    selectedUnit = widget.selectedUnit;
    if (selectedUnit == TemperatureUnit.celsius) {
      celsiusSelected = true;
    } else {
      fahrenheitSelected = true;
    }
  }

  void changeUnit(TemperatureUnit selected) {
    if (selected == TemperatureUnit.celsius) {
      setState(() {
        celsiusSelected = true;
        fahrenheitSelected = false;
        selectedUnit = selected;
      });
    } else if (selected == TemperatureUnit.fahrenheit) {
      setState(() {
        celsiusSelected = false;
        fahrenheitSelected = true;
        selectedUnit = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop(selectedUnit);
            },
            child: Icon(Icons.clear)),
        title: Text("Settings Page"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: Text("Temperature Unit"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TemperatureUnitSelectors(
                            name: "celsius",
                            onSelect: () {
                              changeUnit(TemperatureUnit.celsius);
                            },
                            isSelected: celsiusSelected),
                        TemperatureUnitSelectors(
                            name: "fahrenheit",
                            onSelect: () {
                              changeUnit(TemperatureUnit.fahrenheit);
                            },
                            isSelected: fahrenheitSelected),
                      ]),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, WeatherAppRoutes.addCityPage);
            },
            child: ListTile(
              leading: Icon(Icons.add),
              title: Text("Add new city"),
            ),
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: Country.ALL.length,
                itemBuilder: (BuildContext cx, int index) {
                  return ListTile(
                    leading: Checkbox(
                      value: false,
                    ),
                    title: Text(Country.ALL[index].name),
                  );
                }),
          )
        ],
      ),
    );
  }
}
