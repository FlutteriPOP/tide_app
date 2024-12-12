class QrModel {
  QrModel({
    required this.code,
    required this.message,
    required this.status,
  });

  final String? code;
  final String? message;
  final String? status;

  factory QrModel.fromJson(Map<String, dynamic> json) {
    return QrModel(
      code: json["code"],
      message: json["message"],
      status: json["status"],
    );
  }
}
