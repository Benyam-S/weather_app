import 'package:flutter/material.dart';
import 'package:weather_app/models/src/app_settings.dart';
import 'package:weather_app/pages/add_city_page.dart';
import 'package:weather_app/pages/forecast_page.dart';
import 'package:weather_app/pages/page_container.dart';

void main() {
  AppSettings appSettings = new AppSettings();
  runApp(MyApp(appSettings));
}

RouteObserver<Route> routeObserver = RouteObserver<Route>();

class MyApp extends StatelessWidget {
  final AppSettings appSettings;

  MyApp(this.appSettings);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Weather App",
        routes: {
          WeatherAppRoutes.homePage: (BuildContext context) => PageContainer(
                settings: this.appSettings,
                pageType: ForecastPage(
                  settings: this.appSettings,
                ),
              ),
          WeatherAppRoutes.addCityPage: (BuildContext context) => PageContainer(
                settings: this.appSettings,
                pageType: AddCityPage(
                  settings: this.appSettings,
                ),
              ),
          WeatherAppRoutes.selectCityPage: (BuildContext context) =>
              PageContainer(
                settings: this.appSettings,
              ),
          WeatherAppRoutes.userSettingsPage: (BuildContext context) =>
              PageContainer(
                settings: this.appSettings,
              ),
        },
        navigatorObservers: [routeObserver],
        debugShowCheckedModeBanner: false,
    );
  }
}

class WeatherAppRoutes {
  static final homePage = '/';
  static final addCityPage = '/add';
  static final userSettingsPage = '/settings';
  static final selectCityPage = '/select';
}
