import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glug_app/widgets/timetable.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/services.dart';

String section; int year;
class Routine extends StatefulWidget {



  @override
  _RoutineState createState() => _RoutineState();
}

class _RoutineState extends State<Routine> {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: DynamicTheme.of(context).themeId==1 ? Colors.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child:     Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              }),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Timetable',
                            style: TextStyle(
                                fontFamily: "Nexa-Bold",
                                fontSize: MediaQuery.of(context).size.width * 0.055,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
            SizedBox(height: 20,),
            Expanded(child: TimeTable(section,year))
          ],
        ),
      ),

    );
  }
}
