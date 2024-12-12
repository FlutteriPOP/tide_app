class HolidayModel {
  HolidayModel({
    required this.code,
    required this.message,
    required this.status,
    required this.data,
  });

  final String? code;
  final String? message;
  final String? status;
  final List<Datum> data;

  factory HolidayModel.fromJson(Map<String, dynamic> json) {
    return HolidayModel(
      code: json["code"],
      message: json["message"],
      status: json["status"],
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }
}

class Datum {
  Datum({
    required this.holidayId,
    required this.companyId,
    required this.holidayDate,
    required this.holidayTitle,
    required this.holidayImage,
    required this.holidayDay,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? holidayId;
  final int? companyId;
  final String? holidayDate;
  final String? holidayTitle;
  final String? holidayImage;
  final String? holidayDay;
  final int? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      holidayId: json["holiday_id"],
      companyId: json["company_id"],
      holidayDate: json["holiday_date"],
      holidayTitle: json["holiday_title"],
      holidayImage: json["holiday_image"],
      holidayDay: json["holiday_day"],
      isActive: json["is_active"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }
}
