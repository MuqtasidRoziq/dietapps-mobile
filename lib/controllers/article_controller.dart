import 'package:diet_apps/config/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../controllers/model/article_model.dart';

class ArticleController extends GetxController {
  var homeArticles = <ArticleModel>[].obs;
  var allArticles = <ArticleModel>[].obs;
  var isLoading = false.obs;

  final String Url = "${ConfigApi.baseUrl}/api/articles";

  // Tambahkan Header ini
  final Map<String, String> ngrokHeaders = {
    "ngrok-skip-browser-warning": "true",
    "Accept": "application/json",
  };

  @override
  void onInit() {
    super.onInit();
    fetchHomeArticles();
    fetchAllArticles();
  }

  Future<void> fetchHomeArticles() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('$Url/home'), 
        headers: ngrokHeaders, // Gunakan header di sini
      );
      
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        homeArticles.value = data.map((e) => ArticleModel.fromJson(e)).toList();
      } else {
        print("Server Error Home: ${response.statusCode}");
      }
    } catch (e) {
      print("Error Fetch Home: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchAllArticles({String query = ""}) async {
    try {
      isLoading(true);
      final url = query.isEmpty ? Url : "$Url?q=$query";
      final response = await http.get(
        Uri.parse(url), 
        headers: ngrokHeaders, // Gunakan header di sini juga
      );

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        allArticles.value = data.map((e) => ArticleModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error Fetch All: $e");
    } finally {
      isLoading(false);
    }
  }
}