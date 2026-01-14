import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import '../config/api.dart';

class ProfileController {

  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final uri = Uri.parse('${ConfigApi.baseUrl}/api/get_profile');
      String? token = await storage.read(key: 'jwt_token');

      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "true",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Server Error: ${response.statusCode}");
        return {"error": "Gagal mengambil data profil"};
      }
    } catch (e) {
      print("Error di Controller: $e");
      return {"error": e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required int userId,
    required String name,
    required String email,
    required String gender,
    XFile? imageFile,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST', 
        Uri.parse('${ConfigApi.baseUrl}/api/update_profile'),
      );

      String? token = await storage.read(key: 'jwt_token');
      
      request.headers.addAll({
        "ngrok-skip-browser-warning": "true",
        "Authorization": "Bearer $token"
      });
      request.fields['id'] = userId.toString();
      request.fields['fullname'] = name;
      request.fields['email'] = email;
      request.fields['jenis_kelamin'] = gender;

      if (imageFile != null) {
        var bytes = await imageFile.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'profile_picture',
          bytes,
          filename: imageFile.name,
        ));
      }

      var res = await request.send();
      var response = await http.Response.fromStream(res);
      return json.decode(response.body);
    } catch (e) {
      return {"error": e.toString()};
    }
  }
}