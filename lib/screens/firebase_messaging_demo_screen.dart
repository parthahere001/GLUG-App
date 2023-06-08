import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingDemoApp extends StatefulWidget {
  @override
  _FirebaseMessagingDemoAppState createState() =>
      _FirebaseMessagingDemoAppState();
}

class _FirebaseMessagingDemoAppState extends State<FirebaseMessagingDemoApp> {
  // final FirebaseMessaging _fcm = FirebaseMessaging();
  List<Message> _messages;

  // _getToken() {
  //   _fcm.getToken().then((deviceToken) {
  //     print('Device token: $deviceToken');
  //   });
  // }

  // _configureFirebaseListeners() {
  //   _fcm.configure(onMessage: (Map<String, dynamic> message) async {
  //     print('onMessage: $message');
  //     _setMessage(message);
  //   }, onLaunch: (Map<String, dynamic> message) async {
  //     print('onLaunch: $message');
  //     _setMessage(message);
  //   }, onResume: (Map<String, dynamic> message) async {
  //     print('onResume: $message');
  //     _setMessage(message);
  //   });
  // }

  _setMessage(Map<String, dynamic> message) {
    final notification = message['notification'];
    final data = message['data'];
    final title = notification['title'];
    final body = notification['body'];
    final mMessage = data['message'];

    setState(() {
      Message m = new Message(title, body, mMessage);
      _messages.add(m);
    });
  }

  @override
  void initState() {
    super.initState();
    _messages = List<Message>();
    // _getToken();
    // _configureFirebaseListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Column(
            children: [
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
                          Navigator.of(context).pop(true);
                        }),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontFamily: "Nexa-Bold",
                        fontSize: MediaQuery.of(context).size.width * 0.052,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _messages.isEmpty
                    ? Container(
                        child: Center(
                          child: Text(
                            "No notifications to show",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _messages == null ? 0 : _messages.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 5.0,
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text(
                                _messages[index].message,
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ));
  }
}

class Message {
  String title;
  String body;
  String message;

  Message(title, body, message) {
    this.title = title;
    this.body = body;
    this.message = message;
  }
}
