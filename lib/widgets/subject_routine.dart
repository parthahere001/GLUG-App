import 'package:flutter/material.dart';
import 'package:glug_app/resources/database_provider.dart';
import 'package:glug_app/resources/firestore_provider.dart';
import 'package:glug_app/blocs/attendance_bloc.dart';

class SubjectRoutine extends StatefulWidget {
  final Map map;
  SubjectRoutine({this.map});

  @override
  _SubjectRoutineState createState() => _SubjectRoutineState();
}

class _SubjectRoutineState extends State<SubjectRoutine> {
  _SubjectRoutineState();
  bool isEdit = false;
  final _formKey = GlobalKey<FormState>();
  FirestoreProvider _provider;
  TextEditingController _ctrl1, _ctrl2, _ctrl3, _ctrl4;
  DatabaseProvider _databaseProvider;

  @override
  void initState() {
    super.initState();
    _provider = FirestoreProvider();
    _ctrl1 = TextEditingController();
    // _ctrl2 = TextEditingController();
    // _ctrl3 = TextEditingController();
    // _ctrl4 = TextEditingController();
    _databaseProvider = DatabaseProvider.databaseProvider;
    if (widget.map != null) {
      _ctrl1.text = widget.map["name"];
      // _ctrl2.text = map["total"].toString();
      // _ctrl3.text = map["attended"].toString();
      // _ctrl4.text = map["goal"].toString();
      if (widget.map["name"] != "") isEdit = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _provider = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          SizedBox(
            width: 180.0,
            child: TextFormField(
              controller: _ctrl1,
              decoration: InputDecoration(
                  hintText: "Subject name", hintStyle: TextStyle(fontSize: 13)),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
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
                onPressed: () async {
                  // SAVE NEW SUBJECT IN ROUTINE HERE
                  await _databaseProvider.updateTimetableSubject(
                      widget.map["time"], widget.map["day"], _ctrl1.text);
                  Navigator.pop(context);
                },
                child: Text(
                  isEdit ? 'Edit' : 'Add',
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
