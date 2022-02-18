import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:glug_app/models/notice_model.dart';

class FirestoreProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getCurrentUserID() async {
    User user = _auth.currentUser;
    print(user.uid);
    return user.uid;
  }

  Future<String> getCurrentUserEmail() async {
    final uid = await getCurrentUserID();
    DocumentSnapshot snap = await _firestore.collection("users").doc(uid).get();
    if (snap.exists)
      return snap["email"];
    else
      return "";
  }

  Future<String> getAuthProvider() async {
    User user = _auth.currentUser;
    for (UserInfo userInfo in user.providerData) {
      if (userInfo.providerId == "google.com")
        return 'Google';
      else if (userInfo.providerId == "facebook.com") return 'Facebook';
    }
    return 'Other';
  }

  Stream<DocumentSnapshot> fetchUserData() async* {
    final uid = await getCurrentUserID();
    Stream<DocumentSnapshot> snap =
        _firestore.collection("users").doc(uid).snapshots();
    yield* snap;
  }

  Future<bool> showSurprise() async {
    // final uid = "sUBMozuYLEsONSSB9VOi";
    // DocumentSnapshot doc = await _firestore.collection("users").doc(uid).get();
    // return doc["surprise"];
    return false;
  }

  void addStarredNotice(noticeData) async {
    final uid = await getCurrentUserID();
    DocumentReference ref = _firestore.collection("/users").doc(uid);
    _firestore.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await transaction.get(ref);
      transaction.update(freshSnap.reference, {
        "starred_notices": FieldValue.arrayUnion([noticeData])
      });
    });
  }

  void removeStarredNotice(noticeData) async {
    final uid = await getCurrentUserID();
    DocumentReference ref = _firestore.collection("users").doc(uid);
    _firestore.runTransaction((transaction) async {
      DocumentSnapshot freshSnap = await transaction.get(ref);

      transaction.update(freshSnap.reference, {
        "starred_notices": FieldValue.arrayRemove([noticeData])
      });
    });
  }

  Future<bool> isStarredNotice(title) async {
    print(title);
    final uid = await getCurrentUserID();
    DocumentSnapshot snap = await _firestore.collection("users").doc(uid).get();

    List<dynamic> starredNotices = snap.data()["starred_notices"];
    if (starredNotices != null) {
      starredNotices.forEach((notice) {
        //print("${notice.toString()} title: $title");
        var t = notice["title"].toString();
        print("$title and $t");
        if (t.trim() == title.toString().trim()) {
          return true;
        }
      });
    }
    return false;
  }

  Future<List<String>> fetchStaredNoticeTitle() async {
    final uid = await getCurrentUserID();
    DocumentSnapshot snap = await _firestore.collection("users").doc(uid).get();
    List<String> noticeTitles = new List();
    List<dynamic> starredNotices = snap.data()["starred_notices"];
    if (starredNotices != null) {
      starredNotices.forEach((notice) {
        //print("${notice.toString()} title: $title");
        var t = notice["title"].toString();
        noticeTitles.add(t);
      });
      return noticeTitles;
    }
    return null;
  }

  Future<List<Academic>> fetchStaredNotice() async {
    final uid = await getCurrentUserID();
    DocumentSnapshot snap = await _firestore.collection("users").doc(uid).get();
    List<Academic> notices = new List();
    List<dynamic> starredNotices = snap.data()["starred_notices"];
    if (starredNotices != null) {
      starredNotices.forEach((notice) {
        Academic academic = Academic(
            title: notice["title"].toString(),
            date: notice["date"],
            file: notice["file"]);
        notices.add(academic);
      });
      return notices;
    }
    return null;
  }
}
