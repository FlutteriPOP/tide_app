class ProfileModel {
  String? code;
  String? message;
  String? status;
  List<Data>? data;

  ProfileModel({this.code, this.message, this.status, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? userId;
  String? name;
  String? email;
  String? phoneNumber;
  String? profileImage;
  String? designation;

  Data(
      {this.userId,
      this.name,
      this.email,
      this.phoneNumber,
      this.profileImage,
      this.designation});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    profileImage = json['profile_image'];
    designation = json['designation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['profile_image'] = profileImage;
    data['designation'] = designation;
    return data;
  }
}
