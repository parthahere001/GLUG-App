import 'package:glug_app/models/blog_response.dart';
import 'package:glug_app/models/devto_model.dart';
import 'package:glug_app/models/devto_response.dart';
import 'package:glug_app/models/event_response.dart';
import 'package:glug_app/models/notice_model.dart';
import 'package:glug_app/models/profile_response.dart';
import 'package:glug_app/models/techbytes_response.dart';
import 'package:glug_app/resources/api_provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:glug_app/resources/database_provider.dart';

class Repository {
  final _apiProvider = ApiProvider();

  Future<bool> _isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print("Connected to Mobile Network");
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("Connected to WiFi");
      return true;
    } else {
      print("Unable to connect. Please Check Internet Connection");
      return false;
    }
  }

  bool localDBContains(List listItems, itemToBeSearched) {
    for (var item in listItems) {
      if (item.id == itemToBeSearched.id) return true;
    }
    return false;
  }

  Future<EventResponse> fetchAllEvents() async {
    bool connected = await _isConnected();

    if (connected) {
      EventResponse localDB =
          await DatabaseProvider.databaseProvider.fetchEventData();
      EventResponse apiData = await _apiProvider.fetchEventData();

      apiData.events.forEach((event) {
        if (!localDBContains(localDB.events, event)) {
          DatabaseProvider.databaseProvider.insertEvent(event);
        }
      });
      return _apiProvider.fetchEventData();
    } else {
      return DatabaseProvider.databaseProvider.fetchEventData();
    }
  }

  Future<EventResponse> fetchAllUpcomingEvents() async {
    bool connected = await _isConnected();

    if (connected) {
      EventResponse localDB =
          await DatabaseProvider.databaseProvider.fetchUpcomingEventData();
      EventResponse apiData = await _apiProvider.fetchUpcomingEventData();

      apiData.events.forEach((event) {
        if (!localDBContains(localDB.events, event)) {
          DatabaseProvider.databaseProvider.insertUpcomingEvent(event);
        }
      });
      return _apiProvider.fetchUpcomingEventData();
    } else {
      return DatabaseProvider.databaseProvider.fetchUpcomingEventData();
    }
  }

  Future<BlogResponse> fetchAllBlogPosts() async {
    bool connected = await _isConnected();

    if (connected) {
      BlogResponse localDB =
          await DatabaseProvider.databaseProvider.fetchBlogData();
      BlogResponse apiData = await _apiProvider.fetchBlogData();

      apiData.blogPosts.forEach((blogPost) {
        if (!localDBContains(localDB.blogPosts, blogPost)) {
          DatabaseProvider.databaseProvider.insertBlog(blogPost);
        }
      });
      return _apiProvider.fetchBlogData();
    } else {
      return DatabaseProvider.databaseProvider.fetchBlogData();
    }
  }

  Future<ProfileResponse> fetchAllProfiles() async =>
      _apiProvider.fetchProfileData();

  Future<Notice> fetchAllNotices() async {
    Future<Notice> nn = _apiProvider.fetchNoticeData();
    // print(nn);
    return nn;
  }


  Future<DevToResponse> fetchAllDevTo() async => _apiProvider.fetchDevToData();

  Future<TechbytesResponse> fetchAllTechbytes() async =>
      _apiProvider.fetchTechbytesData();
}
