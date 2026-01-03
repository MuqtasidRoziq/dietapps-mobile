import 'package:shared_preferences/shared_preferences.dart';

class GetUserData {
  Future<Map<String, String?>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getString('id'),
      'gender': prefs.getString('gender'),
      'email': prefs.getString('email'),
      'fullname': prefs.getString('fullname'),
      'photo': prefs.getString('photo'),
    };
  }
}