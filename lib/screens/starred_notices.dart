import 'dart:async';

import 'package:flutter/material.dart';
import 'package:glug_app/models/notice_model.dart';
import 'package:glug_app/resources/firestore_provider.dart';
import 'package:glug_app/widgets/error_widget.dart';
import 'package:glug_app/widgets/notices_tile.dart';

import 'notice_screen.dart';

class StarredNoticeScreen extends StatefulWidget {

  @override
  _StarredNoticeScreenState createState() => _StarredNoticeScreenState();
}

class _StarredNoticeScreenState extends State<StarredNoticeScreen> {
  List<Academic> notices, temp;
  FirestoreProvider _provider;
  StreamController _streamController;
  Stream _stream;

  @override
  void initState() {
    _streamController = StreamController();
    _stream = _streamController.stream;
    _provider = FirestoreProvider();
    _getStaredList();
    temp = new List();
    super.initState();
  }




  @override
  void dispose() {
    super.dispose();
  }

  void _getStaredList() async {
    notices = await _provider.fetchStaredNotice();
    _streamController.add(notices);
  }




  Widget noticeTile(int c, Academic notice) {
    return NoticeTile(
      noticeStarred: true,
      notice: notice,
      onUnStar: (notice) {

        notices.remove(notice);
        for (int i = 0; i < notices.length; i++) {}
        _streamController.sink.add(notices);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: (){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => NoticeScreen(
                )));
      },
    child:
      Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body:
    SafeArea(child:Column(children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NoticeScreen(
                              )));
                    }),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Starred Notices',
                  style: TextStyle(
                      fontFamily: "BebasNeue",
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
            color: Colors.white10,
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: _stream, //noticeBloc.noticeCategories,
                      builder: (context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          notices = snapshot.data;
                          notices = notices.toList();
                          return ListView.builder(
                            padding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 8,
                            ),
                            itemCount: notices.length,
                            itemBuilder: (context, index) {
                              return noticeTile(index, notices[index]);
                            },
                          );
                        } else if (snapshot.hasError) {
                          return errorWidget(snapshot.error);
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }),
                ),
              ],
            ),
          ))
        ]))));
  }
}

//return Container(
//   child: StreamBuilder(
//     stream: noticeBloc.allNoticeData,
//     builder: (context, AsyncSnapshot<Notice> snapshot) {
//       if (snapshot.hasData) {
//         Notice notice = snapshot.data;
//         List<Academic> generalNotices = notice.notices.general;
//         return Scaffold(
//           appBar: AppBar(

//           ),
//         );
//       } else
//         return Center(child: CircularProgressIndicator());
//     },
//   ),
// );
