import 'package:diet_apps/config/api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryController {
  final storage = const FlutterSecureStorage();

  // Hapus parameter 'int userId' karena tidak digunakan lagi di URL
  Future<List<dynamic>> getHistory() async {
    try {
      final String url = '${ConfigApi.baseUrl}/api/history'; 
      
      print("Requesting: $url");
      String? token = await storage.read(key: 'jwt_token');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "true",
          'Authorization': 'Bearer $token' 
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Sesuaikan dengan return jsonify backend kamu: {"success": true, "data": [...]}
        return data['data']; 
      } else {
        print("Server Error ${response.statusCode}: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Kesalahan di Controller: $e");
      return [];
    }
  }
}