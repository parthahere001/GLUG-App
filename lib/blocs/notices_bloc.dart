import 'package:glug_app/models/notice_model.dart';
import 'package:glug_app/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class NoticeBloc {
  final _respository = Repository();
  final _noticesFetcher = BehaviorSubject<Notice>();
  final _noticeCategoryFetcher = BehaviorSubject<List<Academic>>();

  Stream<Notice> get allNoticeData => _noticesFetcher.stream;
  Stream<List<Academic>> get noticeCategories => _noticeCategoryFetcher.stream;

  /*fetchAllData() async {
    Notice notice = await _respository.fetchAllNotices();
    if (!_noticesFetcher.isClosed) _noticesFetcher.sink.add(notice);
  }*/

  fetchCalledNotice(String noticeCategory) async {
    _noticeCategoryFetcher.sink.add(null);
    Notice notice = await _respository.fetchAllNotices();
    if (noticeCategory == "General") {

      List<Academic> calledNotice = notice.notices.general;

      if (!_noticeCategoryFetcher.isClosed)
        _noticeCategoryFetcher.sink.add(calledNotice);
    }
    else if (noticeCategory == "Academic") {
      List<Academic> calledNotice = notice.notices.academic;
      if (!_noticeCategoryFetcher.isClosed)
        _noticeCategoryFetcher.sink.add(calledNotice);
    } else if (noticeCategory == "Student") {
      List<Academic> calledNotice = notice.notices.student;
      if (!_noticeCategoryFetcher.isClosed)
        _noticeCategoryFetcher.sink.add(calledNotice);
    } else if (noticeCategory == "Hostel") {
      List<Academic> calledNotice = notice.notices.hostel;
      if (!_noticeCategoryFetcher.isClosed)
        _noticeCategoryFetcher.sink.add(calledNotice);
    }
  }

  dispose() {
    _noticesFetcher.close();
    _noticeCategoryFetcher.close();
  }
}

final noticeBloc = NoticeBloc();
