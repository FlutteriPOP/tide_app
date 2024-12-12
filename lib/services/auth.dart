import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api.dart';
import '../widgets/toast_widget.dart';

class PassAuth {
  Future changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final body = {'old_password': oldPassword, 'new_password': newPassword};
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final res = await http.post(Uri.parse('$baseUrl/$changePass'),
          body: jsonEncode(body),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          });
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        log(data.toString());
        showToast(data['message']);
        return data;
      } else {
        showToast('${res.statusCode} error');
        log(res.statusCode.toString());
        return null;
      }
    } catch (err) {
      showToast('Something went wrong');
      log(err.toString());
      return null;
    }
  }

  Future forgotPassword(String email) async {
    final body = {
      'email': email,
    };
    final head = {'Content-Type': 'application/json'};

    try {
      final res = await http.post(Uri.parse('$baseUrl/$forgotPass'),
          body: jsonEncode(body), headers: head);
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        showToast(json['message']);
        log(json.toString());
        return json;
      } else {
        showToast('${res.statusCode} error');
        log(res.statusCode.toString());
        return null;
      }
    } catch (err) {
      showToast('Something went wrong');
      log(err.toString());
      return null;
    }
  }
}
