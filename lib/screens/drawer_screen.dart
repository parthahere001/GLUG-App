import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glug_app/models/themes.dart';
import 'package:glug_app/screens/about_us_screen.dart';
import 'package:glug_app/screens/contact_us.dart';
import 'package:glug_app/screens/members_screen.dart';
import 'package:glug_app/resources/firestore_provider.dart';
import 'package:glug_app/services/auth_service.dart';
import 'package:glug_app/services/shared_pref_service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'devto_screen.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  FirestoreProvider _provider;
  bool _surprise = false;
  InAppWebViewController _webViewController;

  List<Map> drawerItems = [
    {'icon': Icons.wc, 'title': "Our team", 'class': MembersScreen()},
    {'icon': Icons.info_outline, 'title': 'About Us', 'class': AboutUS()},
    {'icon': Icons.contacts, 'title': 'Contact Us', 'class': ContactUs()},
    {'icon': FontAwesomeIcons.dev, 'title': 'DEV', 'class': DevToScreen()},
  ];

  bool isDarkTheme = false;

  @override
  void initState() {
    user = _auth.currentUser;
    _provider = FirestoreProvider();
    SharedPrefService.getIsDark().then((value) => {
          setState(() {
            isDarkTheme = value;
          })
        });
    _provider.showSurprise().then((value) {
      setState(() {
        _surprise = value;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _provider = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // isDarkTheme= Theme.of(context).primaryColor == Colors.black;
    return Scaffold(
        backgroundColor: isDarkTheme ? Colors.blueGrey[900] : Colors.grey,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage("images/back.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          child: ClipRRect(
            // make sure we apply clip it properly
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 50, 0, 20),
                alignment: Alignment.center,
                //color: Colors.grey.withOpacity(0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Row(
                    //   children: [
                    //     CircleAvatar(
                    //       backgroundImage: NetworkImage(user.photoURL),
                    //     ),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    // Text(
                    //   user.displayName,
                    //   style: TextStyle(
                    //     // color: Colors.white,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    //         Text(user.email,
                    //             style: TextStyle(
                    //               // color: Colors.white,
                    //               fontWeight: FontWeight.bold,
                    //             ))
                    //       ],
                    //     )
                    //   ],
                    // ),
                    Container(),
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 35.0,
                                  backgroundImage: NetworkImage(user.photoURL),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  user.displayName,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 18,
                            ),
                            Text('Theme  ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            Transform.scale(
                              scale: 1.3,
                              child: Switch(
                                value: isDarkTheme,
                                onChanged: (value) {
                                  setState(() {
                                    isDarkTheme = !isDarkTheme;
                                    Themes.changeTheme(context);
                                    SharedPrefService.saveIsDark(isDarkTheme);
                                  });
                                },
                                activeThumbImage:
                                    AssetImage("images/night.png"),
                                inactiveThumbImage:
                                    AssetImage("images/day.png"),
                                // inactiveThumbImage: ,
                                activeColor: Theme.of(context).accentColor,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: drawerItems
                              .map((element) => Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: ListTile(
                                      leading: Icon(
                                        element['icon'],
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                      title: Text(element['title'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    element['class']));
                                      },
                                    ),
                                  ))
                              .toList(),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.exit_to_app,
                            size: 30,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Log out',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          onTap: () {
                            _provider.getAuthProvider().then((value) {
                              if (value == "Google") {
                                AuthService.signOutGoogle();
                                // .whenComplete(() => Navigator.of(context).pop());
                              }
                            });
                          },
                        ),
                        _surprise
                            ? ListTile(
                                // tileColor: Theme.of(context).accentColor,
                                leading: Text(
                                  "🎉",
                                  style: TextStyle(
                                    fontSize: 30.0,
                                  ),
                                ),
                                title: Text(
                                  'Surprise',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                onTap: () {
                                  Permission.camera.request().whenComplete(() =>
                                      {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                            return Scaffold(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              body: SafeArea(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 10, 0, 0),
                                                      child: Row(
                                                        children: [
                                                          IconButton(
                                                              icon: Icon(
                                                                Icons
                                                                    .arrow_back,
                                                                size: 30,
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(true);
                                                              }),
                                                          SizedBox(
                                                            width: 20,
                                                          ),
                                                          Text(
                                                            'Surprise',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  "Nexa-Bold",
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.052,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: InAppWebView(
                                                          initialUrl:
                                                              "https://himanshu272.github.io/",
                                                          initialOptions:
                                                              InAppWebViewGroupOptions(
                                                            crossPlatform:
                                                                InAppWebViewOptions(
                                                              mediaPlaybackRequiresUserGesture:
                                                                  false,
                                                              debuggingEnabled:
                                                                  true,
                                                            ),
                                                          ),
                                                          onWebViewCreated:
                                                              (InAppWebViewController
                                                                  controller) {
                                                            _webViewController =
                                                                controller;
                                                          },
                                                          androidOnPermissionRequest:
                                                              (InAppWebViewController
                                                                      controller,
                                                                  String origin,
                                                                  List<String>
                                                                      resources) async {
                                                            return PermissionRequestResponse(
                                                                resources:
                                                                    resources,
                                                                action:
                                                                    PermissionRequestResponseAction
                                                                        .GRANT);
                                                          }),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      });
                                },
                              )
                            : SizedBox(),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 5,
                          width: 1000,
                        ),
                        Text(
                          "Developed By The GNU/Linux Users' Group",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
