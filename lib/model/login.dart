class LoginModel {
  LoginModel({
    required this.code,
    required this.message,
    required this.locationPermission,
    required this.status,
    required this.data,
  });

  final String? code;
  final String? message;
  final int? locationPermission;
  final String? status;
  final List<Datum> data;

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      code: json["code"],
      message: json["message"],
      locationPermission: json["location_permission"],
      status: json["status"],
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }
}

class Datum {
  Datum({
    required this.userId,
    required this.companyId,
    required this.token,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
    required this.designation,
  });

  final int? userId;
  final int? companyId;
  final String? token;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? profileImage;
  final String? designation;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      userId: json["user_id"],
      companyId: json["company_id"],
      token: json["token"],
      name: json["name"],
      email: json["email"],
      phoneNumber: json["phone_number"],
      profileImage: json["profile_image"],
      designation: json["designation"],
    );
  }
}
