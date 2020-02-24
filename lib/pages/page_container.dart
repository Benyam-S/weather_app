import 'package:flutter/material.dart';
import 'package:weather_app/models/src/app_settings.dart';

class PageContainer extends StatefulWidget{

  final AppSettings settings;
  final Widget pageType;

  PageContainer({this.settings, this.pageType});

  _PageContainerState createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {


  @override
  Widget build(BuildContext context) {
    return widget.pageType;
  }

}