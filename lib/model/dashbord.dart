class DashboardModel {
  DashboardModel({
    required this.code,
    required this.message,
    required this.status,
    required this.companyImage,
    required this.data,
  });

  final String? code;
  final String? message;
  final String? status;
  final String? companyImage;
  final List<Datum> data;

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      code: json["code"],
      message: json["message"],
      status: json["status"],
      companyImage: json["company_image"],
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }
}

class Datum {
  Datum({
    required this.userId,
    required this.name,
    required this.profileImage,
    required this.designation,
    required this.workingHours,
    required this.breakTime,
    required this.todayFirstCheckIn,
    required this.todayLastCheckOut,
    required this.todayTracking,
    required this.birthdayNotice,
  });

  final int? userId;
  final String? name;
  final String? profileImage;
  final String? designation;
  final String? workingHours;
  final dynamic breakTime;
  final String? todayFirstCheckIn;
  final String? todayLastCheckOut;
  final List<TodayTracking> todayTracking;
  final List<BirthdayNotice> birthdayNotice;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      userId: json["user_id"],
      name: json["name"],
      profileImage: json["profile_image"],
      designation: json["designation"],
      workingHours: json["working_hours"],
      breakTime: json["break_time"],
      todayFirstCheckIn: json["today_first_check_in"],
      todayLastCheckOut: json["today_last_check_out"],
      todayTracking: json["today_tracking"] == null
          ? []
          : List<TodayTracking>.from(
              json["today_tracking"]!.map((x) => TodayTracking.fromJson(x))),
      birthdayNotice: json["birthday_notice"] == null
          ? []
          : List<BirthdayNotice>.from(
              json["birthday_notice"]!.map((x) => BirthdayNotice.fromJson(x))),
    );
  }
}

class BirthdayNotice {
  BirthdayNotice({
    required this.name,
    required this.profileImg,
  });

  final String? name;
  final String? profileImg;

  factory BirthdayNotice.fromJson(Map<String, dynamic> json) {
    return BirthdayNotice(
      name: json["name"],
      profileImg: json["profile_img"],
    );
  }
}

class TodayTracking {
  TodayTracking({
    required this.usersHistoryType,
    required this.usersHistoryTime,
  });

  final String? usersHistoryType;
  final String? usersHistoryTime;

  factory TodayTracking.fromJson(Map<String, dynamic> json) {
    return TodayTracking(
      usersHistoryType: json["users_history_type"],
      usersHistoryTime: json["users_history_time"],
    );
  }
}
