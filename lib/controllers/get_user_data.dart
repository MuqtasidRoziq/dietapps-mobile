import 'package:diet_apps/config/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GetUserData {

  final storage = const FlutterSecureStorage();
  
  Future<Map<String, dynamic>> getUserData() async {

    final prefs = await SharedPreferences.getInstance();
    String? photoName = prefs.getString('profile_picture');
    String? photoUrl;
    if (photoName != null && photoName.isNotEmpty) {
      // Tambahkan timestamp agar cache selalu refresh
      photoUrl = "${ConfigApi.baseUrl}/api/get_image/$photoName?v=${DateTime.now().millisecondsSinceEpoch}";
    }

    return {
      "id": prefs.getString('id'),
      "fullname": prefs.getString('fullname'),
      "gender": prefs.getString('gender'),
      "profile_picture": photoUrl,
      "email": prefs.getString('email'),
    };
  }
}