import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api.dart';
import '../model/dashbord.dart';
import '../model/history.dart';
import '../model/holiday.dart';
import '../model/leave.dart';
import '../model/login.dart';
import '../model/policy.dart';
import '../model/profile.dart';
import '../screens/other/done_page.dart';
import '../widgets/toast_widget.dart';

class ApiClient {
  Future<LoginModel> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('notificationToken');
    final body = jsonEncode({
      'email': email,
      'password': password,
      'device_token': token,
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$loginUrl'),
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        log(response.body);

        log('firebase token: ${token.toString()}');
        return LoginModel.fromJson(responseData);
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to login: $error');
    }
  }

  Future<ProfileModel> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final res = await http.get(Uri.parse('$baseUrl/$profile'), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        return ProfileModel.fromJson(json);
      } else {
        throw Exception('somthing went wrong');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future getDashbordData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final res = await http.get(Uri.parse('$baseUrl/$dashBord'), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        return DashboardModel.fromJson(json);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<HistoryModel> getHistory(String month) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final body = {
        'month': month,
      };
      final header = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final res = await http.post(Uri.parse('$baseUrl/$history'),
          headers: header, body: jsonEncode(body));
      if (res.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(res.body);
        return HistoryModel.fromJson(responseData);
      } else {
        log(res.statusCode.toString());

        throw Exception('Failed to fetch history data');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<LeaveModel> getLeaveData(String leaveType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final postData = {'leave_type': leaveType};
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/$leave'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(postData),
      );
      if (res.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(res.body);
        return LeaveModel.fromJson(responseData);
      } else {
        throw Exception('Failed to post leave data: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to post leave data: $e');
    }
  }

  Future<HolidayModel> getHolidayData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
    try {
      final res = await http.get(Uri.parse('$baseUrl/$holidayList'), headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });
      if (res.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(res.body);
        return HolidayModel.fromJson(responseData);
      } else {
        throw Exception('Failed to fetch holiday data: ${res.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch holiday data: $e');
    }
  }

  Future<ProfileModel> editProfileData({
    String? name,
    String? email,
    String? phone,
    File? image,
    String? role,
  }) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/$editProfile'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      // Add text fields
      request.fields['name'] = name ?? '';
      request.fields['email'] = email ?? '';
      request.fields['phone'] = phone ?? '';
      request.fields['designation'] = role ?? '';

      // Add image file if provided
      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_img',
          image.path,
        ));
      }

      // Send request
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(await response.stream.bytesToString());
        showToast(
          responseData['message'],
        );
        return ProfileModel.fromJson(responseData);
      } else {
        throw Exception(
            'Failed to edit profile data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to edit profile data: $e');
    }
  }

  Future postLeave(
      {required String leaveType,
      required String startDate,
      required String endDate,
      required String reason}) async {
      
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');
    final body = {
      'leave_type': leaveType,
      'leave_start_date': startDate,
      'leave_end_date': endDate,
      'leave_reason': reason,
    };
    final head = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/$addLeave'),
        body: jsonEncode(body),
        headers: head,
      );

      if (res.statusCode == 200) {
        showToast('Leave applied successfully');
        final json = jsonDecode(res.body);
        return json;
      } else {}
    } catch (e) {
      showToast('Something went wrong');
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> postRegistration({
    required String companyName,
    required String email,
    required String phone,
    required String name,
    required String bandwidth,
    required String workingDay,
    required bool radiusCheck,
    String? latitude,
    String? longitude,
    String? radiusRange,
  }) async {
    final Map<String, dynamic> body = {
      'company_name': companyName,
      'company_email': email,
      'company_phone': phone,
      'contact_person': name,
      'employee_bandwith': bandwidth,
      'days_working': workingDay,
      'radius_check': radiusCheck,
      'company_lat': latitude,
      'company_long': longitude,
      'radius_range': radiusRange,
    };

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$registration'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        debugPrint(response.body);
        log(bandwidth);
        showToast(json['message']);
        Get.offAll(
            () => const DonePage(
                  mainText: 'Registration Successful',
                  subText: 'Please check your email for verification.',
                ),
            transition: Transition.rightToLeft);
        return json;
      } else {
        log(response.statusCode.toString());
        throw Exception('Failed to register');
      }
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future getPolicyData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('token');

    final head = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/$companyList'), headers: head);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return PolicyModel.fromJson(json);
      } else {
        log(response.statusCode as String);
        throw Exception('Failed to fetch');
      }
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
