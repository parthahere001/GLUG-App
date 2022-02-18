import 'package:flutter/material.dart';
import 'package:glug_app/blocs/profiles_bloc.dart';
import 'package:glug_app/models/profile_model.dart';
import 'package:glug_app/models/profile_response.dart';
import 'package:glug_app/widgets/error_widget.dart';
import 'package:glug_app/widgets/loader_w.dart';
import 'package:glug_app/widgets/profile_tile.dart';

class MembersScreen extends StatefulWidget {
  static final id = 'membersscreen';

  @override
  _MembersScreenState createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  List<ProfileTile> _finalYears = [];
  List<ProfileTile> _thirdYears = [];
  List<ProfileTile> _secondYears = [];
  List<ProfileTile> _contributors = [];


  Loader loader;

  List contributors = [
    "Avinash",
    "Akshat",
    "Simran",
    "Jyotishka",
    "romit",
    "Souparno",
    "Rishav",
    "Nikhil",
    "Anurag",
    "Subhadip",
    "Srijan",
    "Swastik",
    "Archit",
    "Mayank"
  ];

  @override
  void initState() {
    profilesBloc.fetchAllProfiles();
    loader = Loader();

    super.initState();
  }

  @override
  void dispose() {
    profilesBloc.dispose();
    super.dispose();
  }

  List<Profile> p;

  void _group(List<Profile> profiles) {
    p = new List();
    profiles.forEach((element) {
      p.add(element);
    });

    p.forEach((profile) {
      if (profile.yearName == 2) {
        if (contributors.contains(profile.firstName)) {
          _contributors.add(ProfileTile(
            profile: profile,
            isContributor: true,
          ));
        }
      }
    });

    profiles.sort((a, b) => a.firstName.compareTo(b.firstName));
    profiles.forEach((profile) {
      if (profile.yearName == 2) {
        _secondYears.add(ProfileTile(profile: profile, isContributor: false));
      } else if (profile.yearName == 3) {
        _thirdYears.add(ProfileTile(profile: profile, isContributor: false));
      } else if (profile.yearName == 4) {
        _finalYears.add(ProfileTile(profile: profile, isContributor: false));
      }
    });

    _thirdYears.forEach((profileTile) {
      if (contributors.contains(profileTile.profile.firstName)) {
        _contributors.add(ProfileTile(
          profile: profileTile.profile,
          isContributor: true,
        ));
      }
    });
    _finalYears.forEach((profileTile) {
      if (contributors.contains(profileTile.profile.firstName)) {
        _contributors.add(ProfileTile(
          profile: profileTile.profile,
          isContributor: true,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
            child: Column(children: [
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
                  'Our Team',
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
              child: StreamBuilder(
            stream: profilesBloc.allProfiles,
            builder: (context, AsyncSnapshot<ProfileResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.error != null &&
                    snapshot.data.error.length > 0) {
                  return errorWidget(snapshot.data.error);
                }
                _group(snapshot.data.profiles);
               // loader.dismiss();

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Contributors",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: h / 2.6,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: _contributors,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Final Years",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: h / 3.4,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: _finalYears,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Third Years",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: h / 3.4,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: _thirdYears,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Second Years",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        height: h / 3.4,
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: _secondYears,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return errorWidget(snapshot.error);
              } else
                //loader.showLoader(context);
              return Center(
                  child:CircularProgressIndicator()
              );
            },
          ))
        ])));
  }
}
