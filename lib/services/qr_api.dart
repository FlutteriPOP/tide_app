import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api.dart';
import '../model/qr.dart';

class QrClient {
  Future<QrModel?> postQrApi({
    required double? longitude,
    required double? latitude,
    required String? qrCode,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final body = jsonEncode({
        'latitude': latitude,
        'longitude': longitude,
        'QR_ID': qrCode,
      });

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.post(
        Uri.parse('$baseUrl/$qrscan'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return QrModel.fromJson(data);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('Error in postQrApi: $e');
      return null;
    }
  }
}
