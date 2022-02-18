import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glug_app/models/notice_model.dart';
import 'package:glug_app/blocs/notices_bloc.dart';
import 'package:glug_app/resources/firestore_provider.dart';
import 'package:glug_app/screens/starred_notices.dart';
import 'package:glug_app/widgets/error_widget.dart';
import 'package:glug_app/widgets/notices_tile.dart';
import 'package:glug_app/widgets/loader_w.dart';

class NoticeScreen extends StatefulWidget {
  @override
  _NoticeScreenState createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  List<String> _categories = ['General', 'Academic', 'Student', 'Hostel'];
  String _dropdownvalue;
  Notice notice;
  List<Academic> noticeType;
  FirestoreProvider _provider;
  List<String> _startedLista;
  StreamController _streamController;
  Stream _stream;
  var _userEmail = "";
  Loader loader;
  int loadCount = 0;

  void changeNoticeType(String noticeType) {
    noticeBloc.fetchCalledNotice(noticeType);
    _streamController.add(null);
    _getStaredList();
    setState(() {
      _dropdownvalue = noticeType;
    });
  }

  void _initEmail() async {
    var ins = await _provider.getCurrentUserEmail();
    setState(() {
      _userEmail = ins;
      print(_userEmail);
    });
  }

  @override
  void initState() {
    _dropdownvalue = "General";
    // noticeBloc.fetchAllData();
    noticeBloc.fetchCalledNotice("General");
    _streamController = StreamController();
    _startedLista = new List();
    _stream = _streamController.stream;
    _provider = FirestoreProvider();
    _initEmail();
    _getStaredList();
    loader = Loader();
    super.initState();
  }

  @override
  void dispose() {
    //noticeBloc.dispose();
    super.dispose();
  }

  void _getStaredList() async {
    _startedLista = await _provider.fetchStaredNoticeTitle();
    _streamController.sink.add(_startedLista);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
            child: Column(children: [
          Padding(
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
                        'Notices',
                        style: TextStyle(
                            fontFamily: "Nexa-Bold",
                            fontSize: MediaQuery.of(context).size.width * 0.052,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                      icon: Icon(Icons.star),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StarredNoticeScreen()));
                      })
                ]),
          ),
          Expanded(
              child: Container(
            child: Column(
              children: [
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                        color: Colors.deepOrangeAccent //Color(0xFFE5E5E5),
                        ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: DropdownButton(
                          isExpanded: true,
                          underline: SizedBox(),
                          icon: Icon(Icons.arrow_downward),
                          value: _dropdownvalue,
                          items: _categories
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            changeNoticeType(newValue);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Expanded(
                  child: StreamBuilder(
                      stream: _stream, //noticeBloc.noticeCategories,
                      builder: (context, AsyncSnapshot<dynamic> snapshot1) {
                        if (snapshot1.hasData) {
                          return StreamBuilder(
                              stream: noticeBloc.noticeCategories,
                              builder: (context,
                                  AsyncSnapshot<List<Academic>> snapshot) {
                                if (snapshot.hasData) {
                                  // loadCount++;
                                  // if (loadCount >= 2) {
                                  //   loader.dismiss();
                                  // }
                                  noticeType = snapshot.data;
                                  return ListView.builder(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 0,
                                      horizontal: 8,
                                    ),
                                    itemCount: noticeType.length,
                                    itemBuilder: (context, index) {
                                      bool _isStared = false;
                                      List<dynamic> _startedList =
                                          snapshot1.data;
                                      print("list $_startedList");
                                      for (int i = 0;
                                          i < _startedList.length;
                                          i++) {
                                        print(_startedList[i]);
                                        if (noticeType[index].title ==
                                            _startedList[i]) {
                                          _isStared = true;
                                          break;
                                        }
                                      }
                                      var a = snapshot1.data;
                                      print("data $a");

                                      return NoticeTile(
                                          notice: noticeType[index],
                                          noticeStarred: _isStared,
                                          onUnStar: (value) {});
                                    },
                                  );
                                } else if (snapshot.hasError) {
                                  return errorWidget(snapshot.error);
                                } else {
                                  return Center(
                                      child: Center(
                                          child: CircularProgressIndicator()));
                                }
                              });
                        } else if (snapshot1.hasError) {
                          return errorWidget(snapshot1.error);
                        } else {
                          return Center(child: CircularProgressIndicator());
                          // loader.showLoader(context);
                          // return SizedBox(
                          //   height: 10,
                          // );
                          //Center(child: CircularProgressIndicator());
                        }
                      }),
                ),
              ],
            ),
          ))
        ])));
  }
}
