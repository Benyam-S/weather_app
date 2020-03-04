import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/controllers/fade_transition.dart';
import 'package:weather_app/controllers/forecast_controller.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/models/src/app_settings.dart';
import 'package:weather_app/models/src/forecast_animation_state.dart';
import 'package:weather_app/models/src/weather_data.dart';
import 'package:weather_app/pages/add_city_page.dart';
import 'package:weather_app/pages/settings_page.dart';
import 'package:weather_app/styles.dart';
import 'package:weather_app/utils/forecast_animation_utils.dart';
import 'package:weather_app/utils/humanize.dart';
import 'package:weather_app/widgets/app_menu.dart';
import 'package:weather_app/widgets/clouds_widget.dart';
import 'package:weather_app/widgets/color_transition_box.dart';
import 'package:weather_app/widgets/color_transition_text.dart';
import 'package:weather_app/widgets/forecast_table.dart';
import 'package:weather_app/widgets/sun_widget.dart';
import 'package:weather_app/widgets/time_picker_row.dart';
import 'package:weather_app/widgets/transition_appbar.dart';
import 'package:weather_app/utils/flutter_ui_utils.dart' as ui;
import 'package:weather_app/utils/forecast_animation_utils.dart' as fau;

class ForecastPage extends StatefulWidget {
  final AppSettings settings;

  ForecastPage({Key key, this.settings}) : super(key: key);

  @override
  _ForecastPageState createState() => _ForecastPageState();
}

class _ForecastPageState extends State<ForecastPage>
    with TickerProviderStateMixin {
  ForecastController _forecastController;
  int activeTabIndex;
  ForecastDay selectedForecastDay;
  Forecast selectedForecast;
  List<double> screenRowList = List<double>();
  AnimationController _animationController;
  ForecastAnimationState currentAnimationState;
  ForecastAnimationState nextAnimationState;
  ColorTween _colorTween;
  ColorTween _backgroundColorTween;
  ColorTween _textColorTween;
  ColorTween _cloudColorTween;
  Tween<Offset> _positionOffsetTween;
  TweenSequence<Offset> _cloudPositionOffsetTween;

  @override
  void initState() {
    _forecastController = ForecastController(widget.settings.activeCity);
    selectedForecastDay = _forecastController.selectedDay;
    render();
    super.initState();
  }

  @override
  void didUpdateWidget(ForecastPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    render();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void handleStateChange(int index) {
    if (activeTabIndex == index) return;
    var hour =
    AnimationUtil.getSelectedHourFromTabIndex(index, selectedForecastDay);

    nextAnimationState = AnimationUtil.getDataForNextAnimationState(
        selectedDay: selectedForecastDay, currentlySelectedTimeOfDay: hour);

    initController();
    buildTweens();
    initAnimation();

    setState(() {
      activeTabIndex = index;
      _forecastController.selectedHourlyTemperature =
          ForecastDay.getWeatherForHour(selectedForecastDay, hour);
    });

    currentAnimationState = nextAnimationState;
  }

  void render() {
    currentAnimationState = AnimationUtil.getDataForNextAnimationState(
        selectedDay: selectedForecastDay,
        currentlySelectedTimeOfDay:
        _forecastController.selectedHourlyTemperature.dateTime.hour);
    if (_forecastController.selectedHourlyTemperature.dateTime.hour == 0){
      var starIndex = AnimationUtil.hours
          .indexOf(24);
      handleStateChange(starIndex);
    }else{
      var starIndex = AnimationUtil.hours
          .indexOf(_forecastController.selectedHourlyTemperature.dateTime.hour);
      handleStateChange(starIndex);
    }
  }

  void initController() {
    _animationController?.dispose();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 1000),
    );
  }

  void initAnimation() {
    _animationController.forward();
  }

  void buildTweens() {
    _colorTween = ColorTween(
      begin: currentAnimationState.sunColor,
      end: nextAnimationState.sunColor,
    );
    _backgroundColorTween = ColorTween(
      begin: currentAnimationState.backgroundColor,
      end: nextAnimationState.backgroundColor,
    );
    _textColorTween = ColorTween(
      begin: currentAnimationState.textColor,
      end: nextAnimationState.textColor,
    );
    _cloudColorTween = ColorTween(
      begin: currentAnimationState.cloudColor,
      end: nextAnimationState.cloudColor,
    );
    _positionOffsetTween = Tween<Offset>(
      begin: currentAnimationState.sunOffsetPosition,
      end: nextAnimationState.sunOffsetPosition,
    );

//    var cloudOffsetSequence = OffsetSequence.fromBeginAndEndPositions(
//      currentAnimationState.cloudOffsetPosition,
//      nextAnimationState.cloudOffsetPosition,
//    );
//    _cloudPositionOffsetTween = TweenSequence<Offset>(
//      <TweenSequenceItem<Offset>>[
//        TweenSequenceItem<Offset>(
//          weight: 50.0,
//          tween: Tween<Offset>(
//            begin: cloudOffsetSequence.positionA,
//            end: cloudOffsetSequence.positionB,
//          ),
//        ),
//        TweenSequenceItem<Offset>(
//          weight: 50.0,
//          tween: Tween<Offset>(
//            begin: cloudOffsetSequence.positionB,
//            end: cloudOffsetSequence.positionC,
//          ),
//        ),
//      ],
//    );
  }

  void onTabChanged(int index) {
    handleStateChange(index);
  }

  void onDoubleTapHome() {
    setState(() {
      widget.settings.selectedTemperature =
      widget.settings.selectedTemperature == TemperatureUnit.celsius
          ? TemperatureUnit.fahrenheit
          : TemperatureUnit.celsius;
    });
  }

  void onVerticalDragUpdate(DragUpdateDetails d) {
    double location = d.globalPosition.distance;
    int index = screenRowList
        .indexOf(screenRowList.firstWhere((double r) => r >= location));
    handleStateChange(index);
  }

  String getTemperatureLabel() {
    String value =
    widget.settings.selectedTemperature == TemperatureUnit.celsius
        ? fau.AnimationUtil.temperatureLabels[TemperatureUnit.celsius]
        : fau.AnimationUtil.temperatureLabels[TemperatureUnit.fahrenheit];
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final _currentTemp = Humanize.currentTemperature(
      widget.settings.selectedTemperature,
      _forecastController.selectedHourlyTemperature,
    );

    final _weatherDescription = Humanize.weatherDescription(
        _forecastController.selectedHourlyTemperature);

    final forecastContent = ForecastTableView(
      settings: widget.settings,
      forecast: _forecastController.forecast,
      textAnimation: _textColorTween.animate(_animationController),
    );

    final mainContent = Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          ColorTransitionText(
            text: _weatherDescription,
            style: Theme.of(context).textTheme.headline,
            animation: _textColorTween.animate(_animationController),
          ),
          GestureDetector(
            onTap: (){
              Future<int> qty = showModalBottomSheet<int>(context: context, builder: (BuildContext context){
                return Container(
                  child: Center(
                    child: RaisedButton(
                        child: Text("press"),
                        onPressed: (){
                          Navigator.pop(context,6);
                        },
                      )
                  ),
                  height: 200,
                );
              });
            },
            child: ColorTransitionText(
              text: _currentTemp,
              style: Theme.of(context).textTheme.display3,
              animation: _textColorTween.animate(_animationController),
            ),
          )
        ],
      ),
    );

    final timePickerRow = Flexible(
        child: TimePickerRow(
          tabItems: Humanize.allHours(),
          startIndex: activeTabIndex,
          forecastController: _forecastController,
          onTabChange: onTabChanged,
        ));

    var rowHeight = MediaQuery.of(context).size.height / 8;
    for (int i = 1; i <= 8; i++) {
      screenRowList.add(rowHeight * i);
    }

    return Scaffold(
      drawer: AppMenu(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(ui.appBarHeight(context)),
        child: TransitionAppbar(
            animation: _backgroundColorTween.animate(_animationController),
            leading: ColorTransitionIcon(
                iconData: Icons.location_city,
                animation: _textColorTween.animate(_animationController),
              ),
            title: ColorTransitionText(
              text: widget.settings.activeCity.name,
              style: Theme.of(context).textTheme.title,
              animation: _textColorTween.animate(_animationController),
            ),
            actionIcon: [
              Center(
                  child: Container(
                    padding: EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: (){
                        Future<dynamic> a = Navigator.push(
                          context,
                          FadeTransitionRoute(
                            builder: (BuildContext context){
                              return SettingsPage(selectedUnit: widget.settings.selectedTemperature,);
                            }
                          )
                        );
                        a.then((result){
                          TemperatureUnit d = result;
                          print("-************************--");
                          print(d);
                        });
                      },
                      child: ColorTransitionText(
                        text: getTemperatureLabel(),
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        animation: _textColorTween.animate(_animationController),
                      ),
                    ),
                  ))
            ]),
      ),
      body: GestureDetector(
          onDoubleTap: onDoubleTapHome,
          onVerticalDragUpdate: onVerticalDragUpdate,
          child: ColorTransitionBox(
            animation: _backgroundColorTween.animate(_animationController),
            child: Stack(
              children: [
                SlideTransition(
                  position: _positionOffsetTween.animate(_animationController
                      .drive(CurveTween(curve: Curves.bounceOut))),
                  child: Sun(
                    animation: _colorTween.animate(_animationController),
                  ),
                ),
//              Clouds(
//                isRaining: false,
//                animation: _cloudColorTween.animate(_animationController),
//              ),
                Column(
                  verticalDirection: VerticalDirection.up,
                  children: <Widget>[
                    forecastContent,
                    mainContent,
                    timePickerRow,
                  ],
                )
              ],
            ),
          )),
    );
  }
}
