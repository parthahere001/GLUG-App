import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:glug_app/blocs/timetable_bloc.dart';
import 'package:glug_app/models/timetable_response.dart';
import 'package:glug_app/resources/database_provider.dart';
import 'package:glug_app/resources/routine_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glug_app/widgets/error_widget.dart';
import 'package:glug_app/widgets/timings_routine_form.dart';
import 'subject_routine.dart';

String section;
int year;

RoutineData routineData = RoutineData();

class TimeTable extends StatefulWidget {
  TimeTable(String x, int y) {
    section = x;
    year = y;
  }
  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  dynamic color = {};
  dynamic data;
  //  getData()async{
  //   CollectionReference timetable =
  //   FirebaseFirestore.instance.collection('timetable');
  //   QuerySnapshot querySnapshot = await timetable.get();
  //   List<QueryDocumentSnapshot> lqds = querySnapshot.docs;
  //   DocumentSnapshot documentSnapshot = await timetable.doc(lqds[year-1].id).get();
  //   setState(() {
  //     data = documentSnapshot.data();
  //   });
  //
  // }
  void colorSc() async {
    RoutineData routineData = RoutineData();
    var set = <String>{};
    for (var i = 0; i < 11; i++) {
      for (var j = 0; j < 6; j++) {
        if (data[i][j] != "" &&
            data[i][j].toString().length >= 1 &&
            (i != 0 && j != 0)) set.add(data[i][j].toString());
      }
    }
    int c = 1;
    set.forEach((element) {
      if (c == 19) c = 0;
      // print(element);
      color[element] = routineData.colorScheme[c];
      // print(color[element]);
      c++;
    });
  }

  StreamController _streamController;
  List<Map> list;
  DatabaseProvider _databaseProvider;

  @override
  void initState() {
    super.initState();
    //_provider = FirestoreProvider();
    _databaseProvider = DatabaseProvider.databaseProvider;
    _streamController = StreamController();
    getData();
  }

  getData() async {
    List<Map> timetable;
    try {
      await _databaseProvider.getTimeTableData();
    } catch (error, stacktrace) {
      print("Error: $error, Stacktrace = $stacktrace");
      await _databaseProvider.createTimetable();
    }
    timetable = await _databaseProvider.getTimeTableData();
    timeTableBloc.fetchAllData();
    _streamController.add(timetable);
  }

  @override
  void dispose() {
    super.dispose();
  }

  _addSubjectOrTimingsDialog(context, map, {timings = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          elevation: 5.0,
          backgroundColor: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.65,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Theme.of(context).primaryColor == Colors.black
                  ? Colors.blueGrey[900]
                  : Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 5), blurRadius: 10),
              ],
            ),
            child: (timings)
                ? TimingsRoutine(
                    map: map,
                  )
                : SubjectRoutine(
                    map: map,
                  ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    data = routineData.data;
    // getData();
    // colorSc();
    return
        // (data==null || color==null)?Center(child: CircularProgressIndicator()):
        Padding(
      padding: const EdgeInsets.fromLTRB(9, 0, 9, 7),
      child: StreamBuilder(
          stream: timeTableBloc.allTimeTableData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              data = snapshot.data;

              List<List<dynamic>> dataT = timetableFromMap(data);
              List<List<dynamic>> dataTM = dataT.sublist(1);
              dataTM = List.from(dataTM.map((list) {
                List<dynamic> arr = [];
                for (int i = 1; i < list.length; i++) {
                  arr = arr + [list[i]];
                }
                return arr;
              }));
              dataTM = [dataT[0]] + dataTM;
              data = dataTM;
              print(data);
              colorSc();
              return Container(
                  child: GridView.count(
                      crossAxisCount: 6,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: List.generate(
                        66,
                        (index) {
                          return Padding(
                              padding: const EdgeInsets.all(3),
                              child: InkWell(
                                onTap: () {
                                  if (!((index / 6).toInt() == 0 ||
                                      index % 6 == 0)) {
                                    _addSubjectOrTimingsDialog(context, {
                                      'name':
                                          "${data[(index / 6).toInt()][index % 6]}",
                                      'time':
                                          "${dataT[(index / 6).toInt()][0]}",
                                      'day': "${data[0][index % 6]}",
                                    });
                                    // _addSubjectDialog(context, null);
                                  } else {
                                    String time =
                                        "${data[(index / 6).toInt()][index % 6]}";
                                    String time1 = time
                                        .substring(0, time.indexOf("-"))
                                        .trim();
                                    String time2 = time
                                        .substring(time.indexOf("-") + 1)
                                        .trim();
                                    String meridian1 =
                                        (time1.contains("AM")) ? "AM" : "PM";
                                    String meridian2 =
                                        (time2.contains("AM")) ? "AM" : "PM";
                                    String time1hm = time1
                                        .substring(0, time1.indexOf(meridian1))
                                        .trim();
                                    String time2hm = time2
                                        .substring(0, time2.indexOf(meridian2))
                                        .trim();
                                    String time1h = (time1hm.contains(":"))
                                        ? time1hm
                                            .substring(0, time1hm.indexOf(":"))
                                            .trim()
                                        : time1hm.trim();
                                    String time1m = (time1hm.contains(":"))
                                        ? time1hm
                                            .substring(time1hm.indexOf(":") + 1)
                                            .trim()
                                        : "00";
                                    String time2h = (time2hm.contains(":"))
                                        ? time2hm
                                            .substring(0, time2hm.indexOf(":"))
                                            .trim()
                                        : time2hm.trim();
                                    String time2m = (time2hm.contains(":"))
                                        ? time2hm
                                            .substring(time2hm.indexOf(":") + 1)
                                            .trim()
                                        : "00";
                                    print([
                                      time1h,
                                      time1m,
                                      meridian1,
                                      time2h,
                                      time2m,
                                      meridian2
                                    ]);
                                    _addSubjectOrTimingsDialog(
                                        context,
                                        {
                                          "og":
                                              "${dataT[(index / 6).toInt()][0]}",
                                          "hr1": "$time1h",
                                          "min1": "$time1m",
                                          "mer1": "$meridian1",
                                          "hr2": "$time2h",
                                          "min2": "$time2m",
                                          "mer2": "$meridian2",
                                        },
                                        timings: true);
                                  }
                                },
                                child: Stack(
                                  alignment: AlignmentDirectional.topEnd,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border: (index % 6 == 0 && index != 0)
                                              ? Border.all(
                                                  width: 1.0,
                                                  color:
                                                      (DynamicTheme.of(context)
                                                                  .themeId ==
                                                              1)
                                                          ? Colors.white
                                                          : Colors.black,
                                                )
                                              : null,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: ((index / 6).toInt() == 0 ||
                                                  index % 6 == 0)
                                              ? DynamicTheme.of(context)
                                                          .themeId ==
                                                      1
                                                  ? Colors.black
                                                  : Colors.white
                                              : (data[(index / 6).toInt()]
                                                              [index % 6]
                                                          .toString()
                                                          .length <
                                                      1)
                                                  ? Colors.grey.shade200
                                                  : color[
                                                      data[(index / 6).toInt()]
                                                          [index % 6]]),
                                      child: Center(
                                          child: Transform(
                                              alignment:
                                                  FractionalOffset.center,
                                              transform: new Matrix4.identity()
                                                ..rotateZ(0 * 3.1415927 / 180),
                                              child: ((index / 6).toInt() ==
                                                          0 ||
                                                      index % 6 == 0)
                                                  ? Text(
                                                      "${data[(index / 6).toInt()][index % 6]}",
                                                      // "1",
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.046,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )
                                                  : Text(
                                                      "${data[(index / 6).toInt()][index % 6]}",
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.046,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black),
                                                    )

                                              // "1")
                                              // child: Text("${data[section]["${(index/6).toInt()}"][index%6]}",
                                              // style: TextStyle(
                                              //   fontSize: MediaQuery.of(context).size.width * 0.046,
                                              //   fontWeight: FontWeight.w600
                                              // ),
                                              // ),

                                              )),
                                    ),
                                    (index % 6 == 0 && index != 0)
                                        ? Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(
                                              Icons.edit,
                                              color: (DynamicTheme.of(context)
                                                          .themeId ==
                                                      1)
                                                  ? Colors.white
                                                  : Colors.black,
                                              size: 15,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ));
                        },
                      )));
            } else if (snapshot.hasError) {
              return errorWidget(snapshot.error);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
