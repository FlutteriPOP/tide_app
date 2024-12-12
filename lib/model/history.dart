class HistoryModel {
  HistoryModel({
    required this.code,
    required this.message,
    required this.status,
    required this.month,
    required this.data,
  });

  final String? code;
  final String? message;
  final String? status;
  final String? month;
  final List<Datum> data;

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      code: json["code"],
      message: json["message"],
      status: json["status"],
      month: json["month"],
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }
}

class Datum {
  Datum({
    required this.date,
    required this.day,
    required this.totalHours,
    required this.checkInTime,
    required this.checkOutTime,
    required this.breakTime,
  });

  final String? date;
  final String? day;
  final String? totalHours;
  final String? checkInTime;
  final String? checkOutTime;
  final String? breakTime;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      date: json["date"],
      day: json["day"],
      totalHours: json["total_hours"],
      checkInTime: json["Check_in_time"],
      checkOutTime: json["check_out_time"],
      breakTime: json["break_time"],
    );
  }
}
