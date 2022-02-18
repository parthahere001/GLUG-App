import 'dart:convert';
import 'dart:io';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:glug_app/models/blog_response.dart';
import 'package:glug_app/models/devto_model.dart';
import 'package:glug_app/models/devto_response.dart';
import 'dart:async';
import 'package:glug_app/models/event_response.dart';
import 'package:glug_app/models/notice_model.dart';
import 'package:glug_app/models/profile_response.dart';
import 'package:glug_app/models/techbytes_model.dart';
import 'package:glug_app/models/techbytes_response.dart';

class ApiProvider {
  static final String baseURL = "https://api.nitdgplug.org";
  static final String eventsURL = "$baseURL/api/events/";
  static final String upcomingEventsURL = "$baseURL/api/upcoming-events/";
  static final String blogPostsURL = "$baseURL/blog/posts/";
  static final String profilesURL = "$baseURL/api/profiles/";
  static final String linitURL = "$baseURL/api/linit/";
  static final String carouselURL = "$baseURL/api/carousel/";
  static final String timelineUrl = "$baseURL/api/timeline/";
  static final String techbytesURL = "$baseURL/api/techbytes/";
  static final String noticeURL =
      "http://notices.nitdgplug.org/";
  static final String contactURL = "https://api.nitdgplug.org/api/contact/?format=json";

  static final String purgoMalumURL =
      "https://www.purgomalum.com/service/json?text";

  static final String devToURL =
      "https://dev.to/api/articles?username=nitdgplug";

  final Dio _dio = new Dio();

  Future<String> filterText(String text) async {
    try {
      Response response = await _dio.get("$purgoMalumURL=$text");
      print(response.data);
      Map<String, dynamic> json = response.data;
      return json['result'];
    } catch (error, stackTrace) {
      print("Exception occured: $error stackTrace: $stackTrace");
      return null;
    }
  }

  Future<EventResponse> fetchEventData() async {
    print("Entered");

    try {
      Response response = await _dio.get(eventsURL);
      print(response.data.toString());
      return EventResponse.fromJSON(response.data);
    } catch (error, stackTrace) {
      print("Exception occured: $error stackTrace: $stackTrace");
      return EventResponse.withError("$error");
    }
  }

  Future<EventResponse> fetchUpcomingEventData() async {
    print("Entered");

    try {
      Response response = await _dio.get(upcomingEventsURL);
      print(response.data.toString());
      return EventResponse.fromJSON(response.data);
    } catch (error, stackTrace) {
      print("Exception occured: $error stackTrace: $stackTrace");
      return EventResponse.withError("$error");
    }
  }

  Future<BlogResponse> fetchBlogData() async {
    print("Entered");

    try {
      Response response = await _dio.get(blogPostsURL);
      print(response.data.toString());
      return BlogResponse.fromJSON(response.data);
    } catch (error, stackTrace) {
      print("Exception occured: $error stackTrace: $stackTrace");
      return BlogResponse.withError("$error");
    }
  }

  Future<ProfileResponse> fetchProfileData() async {
    print("Entered");

    try {
      Response response = await _dio.get(profilesURL);
      print(response.data.toString());
      return ProfileResponse.fromJSON(response.data);
    } catch (error, stackTrace) {
      print("Exception occured: $error stackTrace: $stackTrace");
      return ProfileResponse.withError("$error");
    }
  }

  Future<Notice> fetchNoticeData() async {
    try {

      Response response = await _dio.get(noticeURL);
      return Notice.fromJson((response.data));
    }
    catch (error, stackTrace) {
      print("Exception occured: $error stackTrace: $stackTrace");
      return null;
    }
  }
  Future fetchContactData() async {
    try {

      Response response = await _dio.get(contactURL);
       return response.data;
    }
    catch (error, stackTrace) {
      print("Exception occured: $error stackTrace: $stackTrace");
      return null;
    }
  }

  //final Dio _dioDev = new Dio();
  Future<DevToResponse> fetchDevToData() async {
    try {
      Response response = await _dio.get(devToURL);
      print(response.data.toString());
      return DevToResponse.fromJSON(response.data);
    } catch (error, stackTrace) {
      print("Exception occured: $error stackTrace: $stackTrace");
      return null;
    }
  }

  Future<TechbytesResponse> fetchTechbytesData() async {
    try {
      Response response = await _dio.get(techbytesURL);
      print(response.data.toString());
      return TechbytesResponse.fromJSON(response.data);
    } catch (error, stackTrace) {
      print("Exception occured: $error stackTrace: $stackTrace");
      return null;
    }
  }
}
