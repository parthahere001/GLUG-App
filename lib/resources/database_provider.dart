import 'package:glug_app/blocs/timetable_bloc.dart';
import 'package:glug_app/models/blog_post_model.dart';
import 'package:glug_app/models/blog_response.dart';
import 'package:glug_app/models/event_model.dart';
import 'package:glug_app/models/event_response.dart';
import 'package:glug_app/models/timetable_response.dart';
import 'package:glug_app/resources/routine_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:glug_app/blocs/attendance_bloc.dart';

class DatabaseProvider {
  static const String EVENTS_TABLE = "events";
  static const String UPCOMING_EVENTS_TABLE = "upcoming_events";
  static const String ATTENDANCE_TABLE = "attendance";
  static const String EVENT_SHOW = "show_bool";
  static const String EVENT_ID = "id";
  static const String EVENT_IDENTIFIER = "identifier";
  static const String EVENT_TITLE = "title";
  static const String EVENT_DESCRIPTION = "description";
  static const String EVENT_VENUE = "venue";
  static const String EVENT_URL = "url";
  static const String EVENT_TIMING = "event_timing";
  static const String EVENT_FB_LINK = "facebook_link";
  static const String EVENT_IMAGE = "event_image";
  static const String EVENT_STATUS = "status";

  static const String BLOGS_TABLE = "blogs";
  static const String BLOG_SHOW = "show_bool";
  static const String BLOG_ID = "id";
  static const String BLOG_TITLE = "title";
  static const String BLOG_AUTHOR = "author_name";
  static const String BLOG_IMAGE = "thumbnail_image";
  static const String BLOG_CONTENT = "content_body";
  static const String BLOG_DATE = "date_to_show";
  static const String BLOG_COMMENTS = "comments";

  static const String TIME_TABLE = "TIMETABLE";
  static const String TIME = "tme";
  static const String TIMINGS = "timings";
  static const String MONDAY = "Mon";
  static const String TUESDAY = "Tue";
  static const String WEDNESDAY = "Wed";
  static const String THURSDAY = "Thu";
  static const String FRIDAY = "Fri";

  static const String DB_FILE_NAME = "glugDB.db";

  DatabaseProvider._();
  static final DatabaseProvider databaseProvider = DatabaseProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, DB_FILE_NAME);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        print("Creating Events Table");

        await db.execute(
          "CREATE TABLE $EVENTS_TABLE ("
          "$EVENT_ID INTEGER PRIMARY KEY,"
          "$EVENT_SHOW BIT,"
          "$EVENT_IDENTIFIER TEXT,"
          "$EVENT_TITLE TEXT,"
          "$EVENT_DESCRIPTION TEXT,"
          "$EVENT_VENUE TEXT,"
          "$EVENT_URL TEXT,"
          "$EVENT_TIMING TEXT,"
          "$EVENT_FB_LINK TEXT,"
          "$EVENT_IMAGE TEXT,"
          "$EVENT_STATUS TEXT"
          ")",
        );

        print("Creating Attendance Table");

        await db.execute(
          "CREATE TABLE $ATTENDANCE_TABLE ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "total INTEGER,"
          "attended INTEGER,"
          "goal INTEGER,"
          "canceled INTEGER,"
          "holiday INTEGER"
          ")",
        );

        print("Creating Upcoming Events Table");

        await db.execute(
          "CREATE TABLE $UPCOMING_EVENTS_TABLE ("
          "$EVENT_ID INTEGER PRIMARY KEY,"
          "$EVENT_SHOW BIT,"
          "$EVENT_IDENTIFIER TEXT,"
          "$EVENT_TITLE TEXT,"
          "$EVENT_DESCRIPTION TEXT,"
          "$EVENT_VENUE TEXT,"
          "$EVENT_URL TEXT,"
          "$EVENT_TIMING TEXT,"
          "$EVENT_FB_LINK TEXT,"
          "$EVENT_IMAGE TEXT,"
          "$EVENT_STATUS TEXT"
          ")",
        );

        print("Creating Blogs Table");

        await db.execute(
          "CREATE TABLE $BLOGS_TABLE ("
          "$BLOG_ID INTEGER PRIMARY KEY,"
          "$BLOG_SHOW BIT,"
          "$BLOG_TITLE TEXT,"
          "$BLOG_AUTHOR TEXT,"
          "$BLOG_IMAGE TEXT,"
          "$BLOG_CONTENT TEXT,"
          "$BLOG_DATE TEXT,"
          "$BLOG_COMMENTS TEXT"
          ")",
        );
        // print("Creating Timetable");
        // await db.execute("CREATE TABLE $TIME_TABLE ("
        //     "$TIME TEXT PRIMARY KEY,"
        //     "$MONDAY TEXT,"
        //     "$TUESDAY TEXT,"
        //     "$WEDNESDAY TEXT,"
        //     "$THURSDAY TEXT,"
        //     "$FRIDAY TEXT"
        //     ")");
        // await setEmptyTimetable();
      },
    );
  }

  Future<int> createTimetable() async {
    print("Creating Timetable");
    try {
      final db = await database;
      await db.execute("CREATE TABLE $TIME_TABLE ("
          "$TIME TEXT PRIMARY KEY,"
          "$TIMINGS TEXT UNIQUE,"
          "$MONDAY TEXT,"
          "$TUESDAY TEXT,"
          "$WEDNESDAY TEXT,"
          "$THURSDAY TEXT,"
          "$FRIDAY TEXT"
          ")");
      await setEmptyTimetable();
      return 0;
    } catch (error, stackTrace) {
      print("Exception occured: $error stackTrace: $stackTrace");
      return -1;
    }
  }

  Future<EventResponse> fetchEventData() async {
    print("Entered");
    try {
      final db = await database;
      var res = await db.query(EVENTS_TABLE);
      print(res.toString());
      return EventResponse.fromJSON(res);
    } catch (error, stackTrace) {
      print("Exception occured: $error stackTrace: $stackTrace");
      return EventResponse.withError("$error");
    }
  }

  Future<EventResponse> fetchUpcomingEventData() async {
    print("Entered");
    try {
      final db = await database;
      var res = await db.query(UPCOMING_EVENTS_TABLE);
      print(res.toString());
      return EventResponse.fromJSON(res);
    } catch (error, stackTrace) {
      print("Exception occured: $error stackTrace: $stackTrace");
      return EventResponse.withError("$error");
    }
  }

  Future<BlogResponse> fetchBlogData() async {
    print("Entered");
    try {
      final db = await database;
      var res = await db.query(BLOGS_TABLE);
      print(res.toString());
      return BlogResponse.fromJSON(res);
    } catch (error, stackTrace) {
      print("Exception occured: $error stackTrace: $stackTrace");
      return BlogResponse.withError("$error");
    }
  }

  Future<TimetableResponse> fetchTimeTableData() async {
    print("Timetable entered");
    try {
      final db = await database;
      var res = await db.query(TIME_TABLE);
      print(res.toString());
      return TimetableResponse.fromJSON(res);
    } catch (error, stackTrace) {
      print("Exception occured: $error Stacktrace: $stackTrace");
      return TimetableResponse.withError(error);
    }
  }

  Future insertEvent(Event event) async {
    try {
      final db = await database;
      var res = db.insert(EVENTS_TABLE, event.toMap());
      print(res.toString());
      return res;
    } catch (error, stackTrace) {
      print("Exception occured: $error stackTrace: $stackTrace");
      return error;
    }
  }

  Future insertUpcomingEvent(Event event) async {
    try {
      final db = await database;
      var res = db.insert(UPCOMING_EVENTS_TABLE, event.toMap());
      print(res.toString());
      return res;
    } catch (error, stackTrace) {
      print("Exception occured: $error stackTrace: $stackTrace");
      return error;
    }
  }

  Future insertBlog(BlogPost blogPost) async {
    try {
      final db = await database;
      var res = db.insert(BLOGS_TABLE, blogPost.toMap());
      print(res.toString());
      return res;
    } catch (error, stackTrace) {
      print("Exception occured: $error stackTrace: $stackTrace");
      return error;
    }
  }

  /*Future<AttendanceRespose> fetchAttendanceData() async {
    print("Entered");
    try {
      final db = await database;
      var res = await db.query(ATTENDANCE_TABLE);
      print(res.toString());
      return AttendanceRespose.fromJSON(res);
    } catch (error, stackTrace) {
      print("Exception occured: $error stackTrace: $stackTrace");
      return AttendanceRespose.withError("$error");
    }
  }*/

  addNewSubject(String name, int total, int attended, int goal, int canceled,
      int holiday) async {
    final db = await database;
    await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO $ATTENDANCE_TABLE(name, total, attended,goal,canceled,holiday) VALUES("$name",$total,$attended,$goal,$canceled,$holiday)');
      print('inserted1: $id1');
    });
    attendanceBloc.fetchAllData();
  }

  Future<List<Map>> getAttendanceData() async {
    final db = await database;
    List<Map> list = await db.rawQuery('SELECT * FROM $ATTENDANCE_TABLE');
    print(list);
    return list;
  }

  Future<List<Map>> getTimeTableData() async {
    final db = await database;
    List<Map> list = await db.rawQuery("SELECT * FROM $TIME_TABLE");
    print("Get Time Table Data");
    print(list);
    return list;
  }

  addAttedance(int id, int total, int attended) async {
    final db = await database;
    int t = total + 1;
    int a = attended + 1;
    await db.rawUpdate(
        'UPDATE $ATTENDANCE_TABLE SET total = ?, attended = ? WHERE id = ?',
        ['$t', '$a', '$id']);
    attendanceBloc.fetchAllData();
  }

  addNotAttedanded(int id, int total) async {
    final db = await database;
    int t = total + 1;
    await db.rawUpdate(
        'UPDATE $ATTENDANCE_TABLE SET total = ? WHERE id = ?', ['$t', '$id']);
    attendanceBloc.fetchAllData();
  }

  deleteSubject(Map map) async {
    int id = map["id"];
    final db = await database;
    await db.rawDelete('DELETE FROM $ATTENDANCE_TABLE WHERE id = ?', ['$id']);
    attendanceBloc.fetchAllData();
  }

  addHoliday(Map map) async {
    int id = map["id"];
    int holiday = map["holiday"];
    final db = await database;
    int t = holiday + 1;
    await db.rawUpdate(
        'UPDATE $ATTENDANCE_TABLE SET holiday = ? WHERE id = ?', ['$t', '$id']);
    attendanceBloc.fetchAllData();
  }

  addCanceled(Map map) async {
    int id = map["id"];
    int canceled = map["canceled"];
    final db = await database;
    int t = canceled + 1;
    await db.rawUpdate('UPDATE $ATTENDANCE_TABLE SET canceled = ? WHERE id = ?',
        ['$t', '$id']);
    attendanceBloc.fetchAllData();
  }

  updateSubject(int id, String name, int a, int t, int g) async {
    final db = await database;
    await db.rawUpdate(
        'UPDATE $ATTENDANCE_TABLE SET name = ?, total = ?, attended = ?, goal = ? WHERE id = ?',
        ['$name', '$t', '$a', '$g', '$id']);
    print(name);
    attendanceBloc.fetchAllData();
  }

  updateTimetableSubject(String time, String day, String subject) async {
    final db = await database;
    await db.rawUpdate(
        'UPDATE $TIME_TABLE SET $day=? WHERE tme=?', ['$subject', '$time']);
    print(subject);
    timeTableBloc.fetchAllData();
  }

  updateTimeTableTimings(String time, String timings) async {
    final db = await database;
    await db.rawUpdate(
        'UPDATE $TIME_TABLE SET timings=? WHERE tme=?', ['$timings', '$time']);
    timeTableBloc.fetchAllData();
  }

  setEmptyTimetable() async {
    final db = await database;
    List<List<String>> time = RoutineData().data as List<List<String>>;
    for (var i = 1; i < time.length; i++) {
      await db.rawInsert(
          'INSERT INTO $TIME_TABLE VALUES("${RoutineData().data[i][0]}","${RoutineData().data[i][0]}","${RoutineData().data[i][1]}", "${RoutineData().data[i][2]}","${RoutineData().data[i][3]}","${RoutineData().data[i][4]}","${RoutineData().data[i][5]}")');
    }
  }

  deleteTimetable() async {
    final db = await database;
    await db.execute("DROP TABLE IF EXISTS $TIME_TABLE");
  }
}
