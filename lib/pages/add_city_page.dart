import 'package:flutter/material.dart';
import 'package:weather_app/models/src/app_settings.dart';
import 'package:weather_app/models/src/countries.dart';
import 'package:weather_app/utils/flutter_ui_utils.dart' as ui;

class AddCityPage extends StatefulWidget{

  final AppSettings settings;

  AddCityPage({Key key, this.settings}) : super(key: key);

  @override
  _AddCityPageState createState() => _AddCityPageState();

}

class _AddCityPageState extends State<AddCityPage> with TickerProviderStateMixin{

  City _newCity = City.fromUserInput();
  bool _isDefaultFlag = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _formChanged = false;
  List<FocusNode> _focusNodes;
  List<bool> listOfErrors = [false,false];


  @override
  void initState() {
    _focusNodes = [FocusNode(),FocusNode()];
  }

  void _handleAddCity(){
    City newCity = City(
      name: _newCity.name,
      country: _newCity.country,
      active: _isDefaultFlag
    );
    allAddedCities.add(newCity);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(ui.appBarHeight(context)),
        child : AppBar(
            title: Text("Add City"),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Form(
          onChanged: (){
            if (_formChanged) return;
            setState(() {
              _formChanged = true;
            });
          },
//          onWillPop: _onWillPop,
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  focusNode: _focusNodes[0],
                  onSaved: (String val) => _newCity.name =  val,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      helperText: "Required",
                      labelText: "City name"
                  ),
                  autofocus: true,
                  autovalidate: _formChanged,
                  validator: (String val){
                    if (val.isEmpty){
                      listOfErrors[0] = true;
                      listOfErrors[1] = false;
                      return "Should not contain empty value";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  focusNode: _focusNodes[1],
                  onSaved: (String val) => _newCity.name =  val,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      helperText: "optional",
                      labelText: "State or Temporary name"
                  ),
                  autofocus: true,
                  validator: (String val) {
                    if (val.isEmpty) {
                      listOfErrors[0] = false;
                      listOfErrors[1] = true;
                      return "Should not contain empty value";
                    }
                    return null;
                  }
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: DropdownButtonFormField(
                    onChanged: (Country country) {
                      setState(() {
                        _newCity.country = country;
                      });
                    },
                    value: _newCity.country ?? Country.AD,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Country"
                    ),
                    items: Country.ALL.map(
                            (Country country) {
                          return DropdownMenuItem(
                            value: country,
                            child: Text(country.name),
                          );
                        }
                    ).toList(),
                  )
              ),
              FormField(
                  onSaved: (_)=>_newCity.active = _isDefaultFlag,
                  builder: (FormFieldState s) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text("Default City?"),
                        ),
                        Checkbox(
                          value: _isDefaultFlag,
                          onChanged: (bool val){
                            setState(() {
                              _isDefaultFlag = val;
                            });

                          },)
                      ],
                    );
                  }),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    RaisedButton(
                      child: Text("Cancel"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      child: RaisedButton(
                        color: Colors.blue,
                        child: Text("Submit"),
                        onPressed: _formChanged ? (){
                          if (_formKey.currentState.validate()){
                            _formKey.currentState.save();
                            _handleAddCity();
//                            Navigator.pop(context);
                          }else{
                            for(int i = 0; i < listOfErrors.length; i++){
                              if (listOfErrors[i]){
                                FocusScope.of(context).requestFocus(_focusNodes[i]);
                                return;
                              }
                            }
                          }
                        }: null,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
