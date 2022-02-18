import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glug_app/models/notice_model.dart';
import 'package:glug_app/resources/firestore_provider.dart';
import 'package:glug_app/screens/pdf_view_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:glug_app/widgets/loader_w.dart';

class NoticeTile extends StatefulWidget {
  final Academic notice;
  bool noticeStarred;

  final ValueChanged<Academic> onUnStar;

   NoticeTile({Key key, @required this.notice,this.noticeStarred,this.onUnStar})
      : super(key: key);

  @override
  _NoticeTileState createState() => _NoticeTileState();
}

class _NoticeTileState extends State<NoticeTile> {
  FirestoreProvider _provider;

  Loader loader;
  ProgressDialog progressDialog;
  @override
  void initState() {
    super.initState();
    _provider = new FirestoreProvider();

    progressDialog=ProgressDialog(context);
    loader =Loader();

    // _initStarred();
  }

  /*void _initStarred() async {
    bool res = await _provider.isStarredNotice(widget.notice.title);
    print(res.toString());
    setState(() {
      _noticeStarred = res;
    });
  }*/

  @override
  void dispose() {
    super.dispose();
    _provider = null;
  }

  Future<File> _getFileFromUrl() async {
    Dio dio = Dio();
    try {
      String url = widget.notice.file.toString();
      String fileName =
          url.substring(url.lastIndexOf('/') + 1, url.lastIndexOf('.'));
      print(url);
      var response = await dio.get(url,options: Options(responseType: ResponseType.bytes));
      var bytes = response.data;

      var dir = await getTemporaryDirectory();
      File file = File("${dir.path}/$fileName.pdf");
      File urlFile = await file.writeAsBytes(bytes, flush: true);
      return urlFile;
    } catch (error, stackTrace) {
      print("Exception occured: $error stackTrace: $stackTrace");
      return null;
    }
  }

  Widget _tile( String title, String date) {

    return Card(
      elevation: 10,
      margin: new EdgeInsets.symmetric(horizontal: 0.0, vertical: 6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        onTap: () async {
          progressDialog.show();
          File pdfFile = await _getFileFromUrl();
          progressDialog.hide();
          pdfFile != null
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFViewScreen(
                      file: pdfFile,
                      name: widget.notice.title.toString(),
                    ),
                  ),
                )
              : print("PDF file does not exist!");
        },
        contentPadding: EdgeInsets.fromLTRB(20, 10, 10, 10),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(
                      width: 1.0, color: Colors.grey.withOpacity(0.1)))),
          child: Icon(Icons.email, color: Colors.red[400], size: 30.0),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Row(
          children: <Widget>[
            Icon(
              Icons.calendar_today,
              color: Colors.green,
              size: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text("   $date",
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  )),
            )
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            widget.noticeStarred ? Icons.star : Icons.star_border,
            color: widget.noticeStarred ? Colors.red : Colors.black45,
          ),
          onPressed: () {
            setState(() {
              if (!widget.noticeStarred) {
                print(widget.noticeStarred);
                _provider.addStarredNotice({
                  "title": widget.notice.title,
                  "date": widget.notice.date,
                  "file": widget.notice.file
                });
              } else {
                widget.onUnStar(widget.notice);
                _provider.removeStarredNotice({
                  "title": widget.notice.title,
                  "date": widget.notice.date,
                  "file": widget.notice.file
                });
              }
              widget.noticeStarred = !widget.noticeStarred;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _tile( widget.notice.title, widget.notice.date);
  }
}
