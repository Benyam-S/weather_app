import 'package:flutter/material.dart';
import 'package:weather_app/controllers/forecast_controller.dart';

class TimePickerRow extends StatefulWidget {

  final List<String> tabItems;
  final int startIndex;
  final ForecastController forecastController;
  final Function onTabChange;

  TimePickerRow({Key key, this.tabItems, this.startIndex, this.forecastController, this.onTabChange}) : super(key: key);

  @override
  _TimePickerRowState createState() => _TimePickerRowState();

}


class _TimePickerRowState extends State<TimePickerRow> with SingleTickerProviderStateMixin{

  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: widget.tabItems.length,
      initialIndex: widget.startIndex,
    );

    _tabController.addListener(tabBarListener);
    super.initState();
  }

  @override
  void didUpdateWidget(TimePickerRow oldWidget) {
    _tabController.animateTo(widget.startIndex);
    super.didUpdateWidget(oldWidget);
  }

  void tabBarListener(){
    if (_tabController.indexIsChanging){
      return;
    }
    setState(() => widget.onTabChange(_tabController.index));
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: Colors.black,
      unselectedLabelColor: Colors.black38,
      unselectedLabelStyle: Theme.of(context).textTheme.caption.copyWith(fontSize: 10.0),
      labelStyle: Theme.of(context).textTheme.caption.copyWith(fontSize: 12.0),
      indicatorColor: Colors.transparent,
      labelPadding: EdgeInsets.symmetric(horizontal: 48.0, vertical: 8.0),
      controller: _tabController,
      tabs: widget.tabItems.map((t) => Text(t)).toList(),
      isScrollable: true,
    );
  }
}