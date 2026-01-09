import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:diet_apps/config/api.dart';

class ReportController {
  final storage = const FlutterSecureStorage();
  Future<Map<String, dynamic>> getReportData() async {
    try {
      final url = Uri.parse('${ConfigApi.baseUrl}/api/report');
      String? token = await storage.read(key: 'jwt_token');
      final response = await http.get(
        url,
        headers: {
          "ngrok-skip-browser-warning": "true",
          "Authorization": "Bearer $token"
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {};
    } catch (e) {
      return {};
    }
  }
}