import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:glug_app/blocs/blogPosts_bloc.dart';
import 'package:glug_app/blocs/events_bloc.dart';
import 'package:glug_app/blocs/upcoming_events_bloc.dart';
import 'package:glug_app/models/blog_post_model.dart';
import 'package:glug_app/models/blog_response.dart';
import 'package:glug_app/models/event_model.dart';
import 'package:glug_app/models/event_response.dart';
import 'package:glug_app/screens/event_info.dart';
import 'package:glug_app/widgets/error_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:glug_app/screens/club_activity_search.dart';
import 'package:glug_app/widgets/loader_w.dart';


import 'blog_info.dart';

class HomeScreen extends StatefulWidget {
  static final id = 'homescreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Event> eventsList;
  Loader loader;
  int loadCount = 0;

  @override
  void initState() {
    // homeBloc.fetchAllData();
    eventsBloc.fetchAllEvents();
    upcomingEventsBloc.fetchAllUpcomingEvents();
    blogPostsBloc.fetchAllBlogPosts();
    loader = Loader();
    super.initState();
  }

  @override
  void dispose() {
    // homeBloc.dispose();
    eventsBloc.dispose();
    upcomingEventsBloc.dispose();
    blogPostsBloc.dispose();
    super.dispose();
  }

  int i = 0;
  String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  _buildEventList(List<Event> events) {
    events.removeWhere((event) => event.title == null);
    events.removeWhere((event) => DateTime.parse(event.event_timing)
        .toLocal()
        .isBefore(DateTime(DateTime.now().year - 1, 1, 1).toLocal()));
    List<Widget> eventWidgets = events.map((item) {
      var random = getRandString(10);
      print(events.length);
      return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventInfo(event: item, hash: random),
                ));
          },
          child: Stack(children: [
            //Hero(tag: random, child:
            Container(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: item.event_image != null
                      ? CachedNetworkImageProvider(
                          item.event_image,
                        )
                      : AssetImage("images/glug_logo.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // ),

            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50.0,
                child: Center(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                ),
              ),
            ),
          ]));
    }).toList();

    return eventWidgets;
  }

  _buildBlogList(List<BlogPost> blogs) {
    blogs.removeWhere((blog) => blog.title == null);
    List<Widget> blogWidgets = blogs
        .map((item) => GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlogInfo(post: item),
                    ));
              },
              child: Stack(children: [
                Hero(
                    tag: item.title + item.thumbnail_image,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        image: DecorationImage(
                          image: item.thumbnail_image != null
                              ? CachedNetworkImageProvider(
                                  item.thumbnail_image,
                                )
                              : AssetImage("images/glug_logo.jpeg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 50.0,
                    child: Center(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      // color: Color.fromARGB(225, 255, 255, 255),
                    ),
                  ),
                ),
              ]),
            ))
        .toList();

    return blogWidgets;
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
                        'Club Activities',
                        style: TextStyle(
                          fontFamily: "Nexa-Bold",
                          fontSize: MediaQuery.of(context).size.width * 0.052,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 30,
                    ),
                    onPressed: () {
                      if (eventsList != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return ClubActivitySearch(
                              eventList: eventsList,
                            );
                          }),
                        );
                      } else {
                        SnackBar(
                          content: Text('Event data if not fetched yet'),
                          duration: Duration(seconds: 3),
                        );
                      }
                    },
                  ),
                ]),
          ),

              SizedBox(
                height: 10.0,
              ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[


                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15.0),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "OU",
                                style: TextStyle(
                                    fontFamily: "Nexa-Bold",
                                    fontSize:
                                    MediaQuery.of(context).size.width *
                                        0.052,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal),
                              ),
                              Text(
                                "R UPCOMING EV",
                                style: TextStyle(
                                    fontFamily: "Nexa-Bold",
                                    fontSize:
                                    MediaQuery.of(context).size.width *
                                        0.052,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.deepOrange),
                              ),
                              Text(
                                "ENTS",
                                style: TextStyle(
                                  fontFamily: "Nexa-Bold",
                                  fontSize:
                                  MediaQuery.of(context).size.width * 0.052,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ]
                        )
                    ),
                  ),
                  StreamBuilder(
                      stream: upcomingEventsBloc.allUpcomingEvents,
                      builder:
                          (context, AsyncSnapshot<EventResponse> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.error != null &&
                              snapshot.data.error.length > 0)
                            return errorWidget(snapshot.data.error);

                          // loadCount++;
                          // if (loadCount >= 3) {
                          //   loader.dismiss();
                          // }

                          return CarouselSlider(
                            items: _buildEventList(snapshot.data.events),
                            options: CarouselOptions(
                              aspectRatio: 2.5,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 5),
                              autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return errorWidget(snapshot.error);
                        } else
                          return Center(child: CircularProgressIndicator());
                        //   loader.showLoader(context);
                        // return SizedBox(height: 10);
                      }),
                  SizedBox(
                    height: 20.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15.0),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "OU",
                                style: TextStyle(
                                    fontFamily: "Nexa-Bold",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.052,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal),
                              ),
                              Text(
                                "R EV",
                                style: TextStyle(
                                    fontFamily: "Nexa-Bold",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.052,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.deepOrange),
                              ),
                              Text(
                                "ENTS",
                                style: TextStyle(
                                  fontFamily: "Nexa-Bold",
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.052,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ])),
                  ),
                  StreamBuilder(
                      stream: eventsBloc.allEvents,
                      builder:
                          (context, AsyncSnapshot<EventResponse> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.error != null &&
                              snapshot.data.error.length > 0)
                            return errorWidget(snapshot.data.error);
                          loadCount++;
                          // if (loadCount >= 3) {
                          //   loader.dismiss();
                          // }

                          eventsList = snapshot.data.events;
                          return CarouselSlider(
                            items: _buildEventList(snapshot.data.events),
                            options: CarouselOptions(
                              aspectRatio: 2.5,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 5),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return errorWidget(snapshot.error);
                        } else
                          return Center(child: CircularProgressIndicator());
                      }),
                  SizedBox(
                    height: 20.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15.0),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "OU",
                                style: TextStyle(
                                    fontFamily: "Nexa-Bold",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.052,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal),
                              ),
                              Text(
                                "R BL",
                                style: TextStyle(
                                    fontFamily: "Nexa-Bold",
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.052,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.deepOrange),
                              ),
                              Text(
                                "OGS",
                                style: TextStyle(
                                  fontFamily: "Nexa-Bold",
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.052,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ])),
                  ),
                  StreamBuilder(
                      stream: blogPostsBloc.allBlogPosts,
                      builder: (context, AsyncSnapshot<BlogResponse> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.error != null &&
                              snapshot.data.error.length > 0)
                            return errorWidget(snapshot.data.error);
                          // loadCount++;
                          // if (loadCount >= 3) {
                          //   loader.dismiss();
                          // }
                          return CarouselSlider(
                            items: _buildBlogList(snapshot.data.blogPosts),
                            options: CarouselOptions(
                              aspectRatio: 2.5,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 5),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return errorWidget(snapshot.error);
                        } else
                          return Center(child: CircularProgressIndicator());
                      }),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          )
        ])));
  }
}
