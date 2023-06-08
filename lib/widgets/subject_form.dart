import 'package:flutter/material.dart';
import 'package:glug_app/resources/database_provider.dart';
import 'package:glug_app/resources/firestore_provider.dart';
import 'package:glug_app/blocs/attendance_bloc.dart';

class SubjectForm extends StatefulWidget {
  final Map map;
  SubjectForm({this.map});

  @override
  _SubjectFormState createState() => _SubjectFormState(map: map);
}

class _SubjectFormState extends State<SubjectForm> {
  final Map map;
  _SubjectFormState({this.map});

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
    _ctrl2 = TextEditingController();
    _ctrl3 = TextEditingController();
    _ctrl4 = TextEditingController();
    _databaseProvider = DatabaseProvider.databaseProvider;
    if (map != null) {
      _ctrl1.text = map["name"];
      _ctrl2.text = map["total"].toString();
      _ctrl3.text = map["attended"].toString();
      _ctrl4.text = map["goal"].toString();
      isEdit = true;
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
          SizedBox(
            width: 180.0,
            child: TextFormField(
                controller: _ctrl2,
                decoration: InputDecoration(
                    hintText: "Initial total classes",
                    hintStyle: TextStyle(fontSize: 13)),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a valid number';
                  } else if (int.parse(value) <
                      int.parse(_ctrl3.text.toString())) {
                    return 'Initial Presents > Total Classes';
                  }
                  return null;
                },
                keyboardType: TextInputType.number),
          ),
          SizedBox(
            width: 180.0,
            child: TextFormField(
                controller: _ctrl3,
                decoration: InputDecoration(
                    hintText: "Initial presents",
                    hintStyle: TextStyle(fontSize: 13)),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a valid number';
                  } else if (int.parse(value) >
                      int.parse(_ctrl2.text.toString())) {
                    return 'Initial presents > Total classes';
                  }
                  return null;
                },
                keyboardType: TextInputType.number),
          ),
          SizedBox(
            width: 180.0,
            child: TextFormField(
                controller: _ctrl4,
                decoration: InputDecoration(
                    hintText: "Attendance goal in %",
                    hintStyle: TextStyle(fontSize: 13)),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a valid number';
                  } else if (int.parse(value) > 100) {
                    return "Attendance goal > 100%";
                  }
                  return null;
                },
                keyboardType: TextInputType.number),
          ),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
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
              MaterialButton(
                color: Colors.deepOrangeAccent,
                onPressed: () {
                  // if(int.parse(_ctrl3.text)<int.parse(_ctrl2.text)) {
                  if (_formKey.currentState.validate()) {
                    if (isEdit) {
                      _databaseProvider.updateSubject(
                        map["id"],
                        _ctrl1.text.toString(),
                        int.parse(_ctrl3.text.toString()),
                        int.parse(_ctrl2.text.toString()),
                        int.parse(_ctrl4.text.toString()),
                      );
                    } else {
                      _databaseProvider.addNewSubject(
                          _ctrl1.text.toString(),
                          int.parse(_ctrl2.text.toString()),
                          int.parse(_ctrl3.text.toString()),
                          int.parse(_ctrl4.text.toString()),
                          0,
                          0);
                    }

                    Navigator.of(context).pop();
                  }

                  // }
                  // else{
                  //   Scaffold.of(context).showSnackBar(
                  //       new SnackBar(
                  //         content: Text("Initial present should less than total present"),
                  //       )
                  //   );
                  // }
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
