import 'package:glug_app/resources/database_provider.dart';
import 'package:rxdart/rxdart.dart';

class TimeTableBloc {
  DatabaseProvider _databaseProvider = DatabaseProvider.databaseProvider;
  final timetableFetcher = BehaviorSubject<List<Map>>();
  Stream<List<Map>> get allTimeTableData => timetableFetcher.stream;

  fetchAllData() async {
    List<Map> data = await _databaseProvider.getTimeTableData();
    if (!timetableFetcher.isClosed) timetableFetcher.sink.add(data);
  }

  dispose() {
    timetableFetcher.close();
  }
}

final timeTableBloc = TimeTableBloc();
