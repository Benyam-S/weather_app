import 'package:flutter/material.dart';
import 'package:weather_app/main.dart';

class AppMenu extends StatefulWidget{

  _AppMenuState createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> with RouteAware{

  String _activeMenu;
  Map<String, bool> menuMap = {
    WeatherAppRoutes.homePage: false,
    WeatherAppRoutes.addCityPage: false,
    WeatherAppRoutes.selectCityPage: false,
    WeatherAppRoutes.userSettingsPage: false,
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPush() {
    super.didPush();
    _activeMenu = ModalRoute.of(context).settings.name;
    menuMap.forEach((String key, bool value){
      menuMap[key] = false;
    });
    menuMap[_activeMenu] = true;
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
        child:ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('images/logo.jpg'),
              ),
              accountEmail: Text("Binysimayehu@gmail.com"),
              accountName: Text("Benyam Simayehu"),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              selected: menuMap[WeatherAppRoutes.homePage],
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add City"),
              selected: menuMap[WeatherAppRoutes.addCityPage],
            ),
            ListTile(
              leading: Icon(Icons.select_all),
              title: Text("Select City"),
              selected: menuMap[WeatherAppRoutes.selectCityPage],
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              selected: menuMap[WeatherAppRoutes.userSettingsPage],
            ),
            AboutListTile(
              icon: Icon(Icons.info),
              applicationName: "Weather App!",
              aboutBoxChildren: <Widget>[
                Text("Thank you for reading this.")
              ],
            ),
          ],
        )
    );
  }

}