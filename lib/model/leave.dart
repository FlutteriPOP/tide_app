class LeaveModel {
  LeaveModel({
    required this.code,
    required this.message,
    required this.status,
    required this.pendingCount,
    required this.approvedCount,
    required this.cancleCount,
    required this.leaveBalance,
    required this.data,
  });

  final String? code;
  final String? message;
  final String? status;
  final int? pendingCount;
  final int? approvedCount;
  final int? cancleCount;
  final int? leaveBalance;
  final List<Datum> data;

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      code: json["code"],
      message: json["message"],
      status: json["status"],
      pendingCount: json["pendingCount"],
      approvedCount: json["approvedCount"],
      cancleCount: json["cancleCount"],
      leaveBalance: json["leaveBalance"],
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }
}

class Datum {
  Datum({
    required this.startDate,
    required this.endDate,
    required this.leaveStatus,
    required this.cancelReason,
    required this.applyDay,
    required this.approvedBy,
  });

  final String? startDate;
  final String? endDate;
  final String? leaveStatus;
  final String? cancelReason;
  final int? applyDay;
  final dynamic approvedBy;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      startDate: json["start_date"],
      endDate: json["end_date"],
      leaveStatus: json["leave_status"],
      cancelReason: json["cancel_reason"],
      applyDay: json["apply_day"],
      approvedBy: json["approved_by"],
    );
  }
}
