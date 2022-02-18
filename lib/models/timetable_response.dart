import 'package:glug_app/resources/routine_data.dart';

List<List<dynamic>> timetableFromMap(dynamic jsons) {
  List<List<dynamic>> timetable = List<List<dynamic>>.from(jsons.map((json) => [
        json['tme'],
        json['timings'],
        json['Mon'],
        json['Tue'],
        json['Wed'],
        json['Thu'],
        json['Fri']
      ]));
  List<List<dynamic>> timetableFinal =
      [RoutineData().data[0] as List<dynamic>] + timetable;
  return timetableFinal;
}

class TimetableResponse {
  List<List<String>> timetable;
  String error;

  TimetableResponse.fromJSON(List<dynamic> jsons)
      : timetable = timetableFromMap(jsons),
        error = '';

  TimetableResponse.withError(String errorVal)
      : timetable = [],
        error = errorVal;
}
