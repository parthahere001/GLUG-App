class Notice {
  Notice({
    this.notices,
  });

  final Notices notices;

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
    notices: Notices.fromJson(json["notices"]),
  );
}

class Notices {
  Notices({
    this.general,
    this.student,
    this.academic,
    this.hostel,
  });

  final List<Academic> general;
  final List<Academic> student;
  final List<Academic> academic;
  final List<Academic> hostel;

  factory Notices.fromJson(Map<String, dynamic> json) => Notices(
    general: List<Academic>.from(
        json["General"].map((x) => Academic.fromJson(x))),
    student: List<Academic>.from(
        json["Student"].map((x) => Academic.fromJson(x))),
    academic: List<Academic>.from(
        json["Academic"].map((x) => Academic.fromJson(x))),
    hostel: List<Academic>.from(
        json["Hostel"].map((x) => Academic.fromJson(x))),
  );
}

class Academic {
  Academic({
    this.title,
    this.file,
    this.date,
  });

  final String title;
  final String file;
  final String date;

  factory Academic.fromJson(Map<String, dynamic> json) => Academic(
    title:json["title"],
    file: json["file"],
    date: json["date"],
  );
}