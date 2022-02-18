import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glug_app/resources/database_provider.dart';
import 'package:glug_app/resources/firestore_provider.dart';

class TimingsRoutine extends StatefulWidget {
  final Map map;
  TimingsRoutine({this.map});

  @override
  TimingsRoutineState createState() => TimingsRoutineState();
}

class TimingsRoutineState extends State<TimingsRoutine> {
  final _formKey = GlobalKey<FormState>();
  FirestoreProvider _provider;
  TextEditingController _ctrl1, _ctrl2, _ctrl3, _ctrl4;
  String meridian1, meridian2;
  List<String> meridianOptions = ["AM", "PM"];
  DatabaseProvider _databaseProvider;

  void initState() {
    super.initState();
    meridian1 = "AM";
    meridian2 = "AM";
    _ctrl1 = TextEditingController();
    _ctrl2 = TextEditingController();
    _ctrl3 = TextEditingController();
    _ctrl4 = TextEditingController();
    _databaseProvider = DatabaseProvider.databaseProvider;
    if (widget.map != null) {
      _ctrl1.text = widget.map["hr1"];
      _ctrl2.text = widget.map["min1"];
      meridian1 = widget.map["mer1"];
      _ctrl3.text = widget.map["hr2"];
      _ctrl4.text = widget.map["min2"];
      meridian2 = widget.map["mer2"];
    }
  }

  @override
  void dispose() {
    super.dispose();
    _provider = null;
  }

  bool timeValidation(String hr1, String min1, String mer1, String hr2,
      String min2, String mer2) {
    if (mer1 == "PM" && mer2 == "AM") return false;
    if (mer1 == mer2) {
      return (((int.parse(hr2) - int.parse(hr1)) * 60 +
              (int.parse(min2) - int.parse(min1))) >
          0);
    }
    if (int.parse(hr2) == 12) {
      return (((int.parse(hr2) - int.parse(hr1)) * 60 +
              (int.parse(min2) - int.parse(min1))) >
          0);
    }
    return (((int.parse(hr2) - int.parse(hr1) + 12) * 60 +
            (int.parse(min2) - int.parse(min1))) >
        0);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Fill Details",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 30.0,
                    child: TextFormField(
                        controller: _ctrl1,
                        decoration: InputDecoration(
                            hintText: "hh", hintStyle: TextStyle(fontSize: 13)),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a valid number';
                          } else if (int.parse(value) > 12) {
                            return "";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number),
                  ),
                  Text(
                    ":",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 30.0,
                    child: TextFormField(
                        controller: _ctrl2,
                        decoration: InputDecoration(
                            hintText: "mm", hintStyle: TextStyle(fontSize: 13)),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a valid number';
                          } else if (int.parse(value) > 59) {
                            return "";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number),
                  ),
                  Text(
                    "-",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 30.0,
                    child: TextFormField(
                        controller: _ctrl3,
                        decoration: InputDecoration(
                            hintText: "hh", hintStyle: TextStyle(fontSize: 13)),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a valid number';
                          } else if (int.parse(value) > 12) {
                            return "";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number),
                  ),
                  Text(
                    ":",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 30.0,
                    child: TextFormField(
                        controller: _ctrl4,
                        decoration: InputDecoration(
                            hintText: "mm", hintStyle: TextStyle(fontSize: 13)),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a valid number';
                          } else if (int.parse(value) > 59) {
                            return "";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 50,
                    child: DropdownButton<String>(
                      value: meridian1,
                      onChanged: (mer) {
                        setState(() {
                          meridian1 = mer;
                        });
                      },
                      items: meridianOptions
                          .map<DropdownMenuItem<String>>(
                            (op) => DropdownMenuItem(
                              child: Text(op),
                              value: op,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: DropdownButton<String>(
                      value: meridian2,
                      onChanged: (mer) {
                        setState(() {
                          meridian2 = mer;
                        });
                      },
                      items: meridianOptions
                          .map<DropdownMenuItem<String>>(
                            (op) => DropdownMenuItem(
                              child: Text(op),
                              value: op,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FlatButton(
                    color: Colors.deepOrangeAccent,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FlatButton(
                    color: Colors.deepOrangeAccent,
                    onPressed: () {
                      print("pressed");
                      print(timeValidation(_ctrl1.text, _ctrl2.text, meridian1,
                          _ctrl3.text, _ctrl4.text, meridian2));
                      // if(int.parse(_ctrl3.text)<int.parse(_ctrl2.text)) {
                      if (_formKey.currentState.validate() &&
                          timeValidation(_ctrl1.text, _ctrl2.text, meridian1,
                              _ctrl3.text, _ctrl4.text, meridian2)) {
                        // print([
                        //   _ctrl1.text,
                        //   _ctrl2.text,
                        //   meridian1,
                        //   _ctrl3.text,
                        //   _ctrl4.text,
                        //   meridian2
                        // ]);
                        String time1 = _ctrl1.text +
                            ((_ctrl2.text == "00")
                                ? ""
                                : (int.parse(_ctrl2.text) <= 9)
                                    ? ":0${int.parse(_ctrl2.text)}"
                                    : (":" + _ctrl2.text)) +
                            " " +
                            meridian1;
                        String time2 = _ctrl3.text +
                            ((_ctrl4.text == "00")
                                ? ""
                                : (int.parse(_ctrl4.text) <= 9)
                                    ? ":0${int.parse(_ctrl4.text)}"
                                    : (":" + _ctrl4.text)) +
                            " " +
                            meridian2;
                        String connecter = " -\n";
                        String time = time1 + connecter + time2;

                        print(time);
                        _databaseProvider.updateTimeTableTimings(
                            widget.map["og"], time);
                        Navigator.of(context).pop();
                      }

                      // else {
                      //   Scaffold.of(context).showSnackBar(new SnackBar(
                      //     content: Text(
                      //         "Initial present should less than total present"),
                      //   ));
                      // }
                    },
                    child: Text(
                      'Edit',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
