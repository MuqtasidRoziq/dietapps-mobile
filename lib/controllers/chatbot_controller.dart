import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:diet_apps/config/api.dart';

class Chatbot{

  static const String url = '${ConfigApi.baseUrl}/api/chatbot';

  Future<String> askChatbot(String question) async {

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'question': question}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['answer'];
    } else {
      return "Gagal mendapatkan jawaban: ${response.statusCode}";
    }
  }
}
