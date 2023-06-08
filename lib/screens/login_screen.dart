import 'package:flare_loading/flare_loading.dart';
import 'package:flutter/material.dart';
import 'package:glug_app/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                    // child: FlareActor(
                    //   "images/Bart.flr",
                    //   animation: "Excited Hi",
                    //   alignment: Alignment.center,
                    // ),
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
              // SizedBox(
              //   height: 100.0,
              // ),
              // CircleAvatar(
              //   radius: 60.0,
              //   backgroundImage: AssetImage("images/glug_logo.jpeg"),
              // ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              _signInButton(type: "Google", context: context),
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              // _signInButton(type: "GitHub", context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton({String type, BuildContext context}) {
    return MaterialButton(
      elevation: 10.0,
      splashColor: Colors.grey,
      onPressed: () {
        if (type == "Google") {
          AuthService.signInWithGoogle();
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: type == "Google"
                    ? AssetImage("images/google_logo.png")
                    : AssetImage("images/github_logo.png"),
                height: 35.0),
            SizedBox(
              width: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                type == "Google"
                    ? 'Sign in with Google'
                    : 'Sign in with GitHub',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.black54,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
