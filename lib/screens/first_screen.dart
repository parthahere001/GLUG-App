import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:glug_app/screens/firebase_messaging_demo_screen.dart';
import 'package:glug_app/screens/home_screen.dart';
import 'package:glug_app/screens/notice_screen.dart';
import 'routine.dart';

import 'attendance_tracker_screen.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final _ctrl = PageController();
  int _currentPage = 0;
  List<Map<String, dynamic>> data = [
    {
      "title": "Our Activities\nand Workshops",
      "body": "Wanna know what we're all about? Come, explore the Source!",
      "image": "images/eventArtboard.png",
      "color": Color(0xFFE83D56),
      "route": HomeScreen(),
    },
    {
      "title": "Track Your\nAttendance",
      "body": "Feel free to skip a class cause you're never falling behind!",
      "image": "images/attendArtboard.png",
      "color": Color(0xFF71C978),
      "route": AttendanceTrackerScreen(),
    },
    {
      "title": "Browse Institute\nNotices",
      "body": "Now you'll never miss an important update from the institute!",
      "image": "images/noticeArtboard.png",
      "color": Color(0xFF8DB6FA),
      "route": NoticeScreen(),
    },
    {
      "title": "Customise\nyour Timetable",
      "body": "Build a customised routine for your daily schedule!",
      "image": "images/timeTable.png",
      "color": Color(0xFF877FF0),
      "route": Routine(),
    },
  ];

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() {
      int next = _ctrl.page.round();

      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _buildPage(context, i) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data[i]["title"],
              style: TextStyle(
                fontFamily: "Nexa-Bold",
                fontSize: screenWidth * 0.1,
                fontWeight: FontWeight.w700,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (!isDrawerOpen) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctxt) => data[i]["route"]));
                } else {
                  setState(() {
                    xOffset = 0;
                    yOffset = 0;
                    scaleFactor = 1;
                    isDrawerOpen = false;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                height: screenHeight * 0.65,
                width: screenWidth * 0.88,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data[i]["body"],
                      style: TextStyle(
                          fontFamily: "SourceSansPro",
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700),
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          height: screenWidth * 0.7,
                          width: screenWidth * 0.8,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage(data[i]["image"]),
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 5.0,
                        right: 5.0,
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: isDrawerOpen
                            ? SizedBox()
                            : Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 30.0,
                              ),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: data[i]["color"],
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            // SizedBox(
            //   height: screenHeight * 0.0005,
            // ),
          ],
        ),
      ),
    );
  }

  _buildDots() {
    int items = 4;

    List<Widget> dots = [];

    for (int i = 0; i < items; i++) {
      double s = i == _currentPage ? 10.0 : 8.0;
      Color c = i == _currentPage
          ? (DynamicTheme.of(context).themeId == 1
              ? Colors.white
              : Colors.black)
          : Colors.grey;
      dots.add(
        AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: 2.5),
          height: s,
          width: s,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(s),
          ),
        ),
      );
    }

    return dots;
  }

  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          xOffset = 0;
          yOffset = 0;
          scaleFactor = 1;
          isDrawerOpen = false;
        });
      },
      child: AnimatedContainer(
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(scaleFactor)
            ..rotateY(isDrawerOpen ? -0.5 : 0),
          duration: Duration(milliseconds: 250),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0)),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isDrawerOpen ? 40 : 0.0),
              bottomLeft: Radius.circular(isDrawerOpen ? 40 : 0.0),
            ),
            child: Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              body: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: isDrawerOpen
                              ? SizedBox()
                              : IconButton(
                                  icon: Icon(Icons.sort),
                                  iconSize: 35.0,
                                  color: (DynamicTheme.of(context).themeId == 1
                                      ? Colors.white
                                      : Colors.black),
                                  onPressed: () {
                                    setState(() {
                                      xOffset = 200;
                                      yOffset = 150;
                                      scaleFactor = 0.6;
                                      isDrawerOpen = true;
                                    });
                                  }),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.02,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _buildDots(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: isDrawerOpen
                              ? SizedBox()
                              : IconButton(
                                  icon: Icon(Icons.notifications),
                                  iconSize: 30.0,
                                  color: (DynamicTheme.of(context).themeId == 1
                                      ? Colors.white
                                      : Colors.black),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                        return FirebaseMessagingDemoApp();
                                      }),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _ctrl,
                        itemCount: 4,
                        itemBuilder: (ctxt, index) {
                          return _buildPage(context, index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
