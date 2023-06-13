import 'dart:async';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_loading/flare_loading.dart';
import 'package:flutter/material.dart';
import 'package:glug_app/screens/drawer_screen.dart';
import 'package:glug_app/screens/intro_screen.dart';
import 'package:glug_app/services/auth_service.dart';
import 'package:glug_app/services/shared_pref_service.dart';

import 'first_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isIntroDone = false;
  Widget _getScreen() {
    return StreamBuilder<User>(
      stream: AuthService.authStateChanges,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData)
          return Scaffold(
              body: DoubleBackToCloseApp(
                  snackBar: const SnackBar(
                    content: Text('Tap back again to leave'),
                  ),
                  child: Stack(
                    children: [
                      // DrawerScreen(),
                      FirstScreen(),
                    ],
                  )));
        else
          return LoginScreen();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // SharedPrefService.getIntroDone().then((isDone) {
    //   setState(() {
    //     _isIntroDone = isDone;
    //   });
    // });
    Timer(
      Duration(seconds: 2),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) {
          return FirstScreen();
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("images/back.jpeg"),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 100.0,
              ),
              Container(
                width: (MediaQuery.of(context).size.width),
                height: 50,
                color: Colors.black54,
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "GNU LIN",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Nexa-Bold",
                            fontSize: MediaQuery.of(context).size.width * 0.052,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        "UX US",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Nexa-Bold",
                            fontSize: MediaQuery.of(context).size.width * 0.052,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange),
                      ),
                      Text(
                        "ERS' GR",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Nexa-Bold",
                            fontSize: MediaQuery.of(context).size.width * 0.052,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        "OUP",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Nexa-Bold",
                            fontSize: MediaQuery.of(context).size.width * 0.052,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: FlareLoading(
                      fit: BoxFit.fitHeight,
                      name: 'images/Bart.flr',
                      // startAnimation: 'walk',
                      loopAnimation: 'Excited Hi',
                      // endAnimation: 'walk',
                      onSuccess: (_) {},
                      onError: (_, __) {},
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
