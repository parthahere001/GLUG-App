import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glug_app/screens/drawer_screen.dart';
import 'package:glug_app/screens/first_screen.dart';
import 'package:glug_app/screens/login_screen.dart';
import 'package:glug_app/services/auth_service.dart';
import 'package:glug_app/services/shared_pref_service.dart';
import 'package:intro_slider/intro_slider.dart';
// import 'package:intro_slider/slide_object.dart';

class IntroScreen extends StatefulWidget {
  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  // List<Slide> slides = new List();

  Widget _getScreen() {
    return StreamBuilder<User>(
      stream: AuthService.authStateChanges,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData)
          return Stack(
            children: [
              DrawerScreen(),
              FirstScreen(),
            ],
          );
        else
          return LoginScreen();
      },
    );
  }

  @override
  void initState() {
    super.initState();

    // slides.add(
    //   new Slide(
    //     description: "Get up, stretch your arms and take a seat.Let's code!",
    //     pathImage: "images/splash_1.gif",
    //     widthImage: 300,
    //     heightImage: 300,
    //     backgroundColor: Color(0xff1C1C3C),
    //   ),
    // );
    // slides.add(
    //   new Slide(
    //     description:
    //         "Be sure to make the tiniest of adjustments. They go a long way.",
    //     pathImage: "images/splash_2.gif",
    //     widthImage: 300,
    //     heightImage: 300,
    //     backgroundColor: Color(0xff1C1C3C),
    //   ),
    // );
    // slides.add(
    //   new Slide(
    //     description:
    //         "All the hard work pays off and Voila! You have a brand new application.",
    //     pathImage: "images/splash_3.gif",
    //     widthImage: 300,
    //     heightImage: 300,
    //     backgroundColor: Color(0xff1C1C3C),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      // slides: this.slides,
      onDonePress: () {
        SharedPrefService.saveIntroDone().whenComplete(() {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) {
              return _getScreen();
            }),
          );
        });
      },
    );
  }
}
