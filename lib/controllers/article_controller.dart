import 'package:diet_apps/config/api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../controllers/model/article_model.dart';

class ArticleController extends GetxController {
  var homeArticles = <ArticleModel>[].obs;
  var allArticles = <ArticleModel>[].obs;
  var isLoading = false.obs;
  var isLoadingHome = false.obs;
  
  // Tambahkan error state
  var homeError = ''.obs;
  var allError = ''.obs;

  final String Url = "${ConfigApi.baseUrl}/api/articles";

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

  Future<void> fetchHomeArticles({http.Client? client}) async {
    final httpClient = client ?? http.Client();
    try {
      isLoadingHome(true);
      homeError(''); // Reset error
      
      final response = await httpClient.get(
        Uri.parse('$Url/home'),
        headers: ngrokHeaders,
      ).timeout(const Duration(seconds: 15)); // Tambahkan timeout

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        homeArticles.value = data.map((e) => ArticleModel.fromJson(e)).toList();
        homeError('');
      } else {
        homeError('Gagal memuat artikel (${response.statusCode})');
        print("Error Status: ${response.statusCode}");
      }
    } catch (e) {
      homeError('Tidak dapat terhubung ke server');
      print("Error Fetch Home: $e");
    } finally {
      isLoadingHome(false);
    }
  }

  Future<void> fetchAllArticles({String query = ""}) async {
    try {
      isLoading(true);
      allError(''); // Reset error
      
      final url = query.isEmpty ? Url : "$Url?q=$query";
      final response = await http.get(
        Uri.parse(url),
        headers: ngrokHeaders,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        allArticles.value = data.map((e) => ArticleModel.fromJson(e)).toList();
        allError('');
      } else {
        allError('Gagal memuat artikel (${response.statusCode})');
        print("Error Status: ${response.statusCode}");
      }
    } catch (e) {
      allError('Tidak dapat terhubung ke server');
      print("Error Fetch All: $e");
    } finally {
      isLoading(false);
    }
  }

  var currentArticle = {}.obs;
  var isLoadingDetail = false.obs;
  var detailArticle = ArticleModel(id: 0, title: '').obs;

  Future<void> getDetailArticle(int id) async {
    try {
      isLoadingDetail(true);
      final response = await http.get(
        Uri.parse('${ConfigApi.baseUrl}/api/articles/$id'),
        headers: ngrokHeaders,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        detailArticle.value = ArticleModel.fromJson(data);
      }
    } catch (e) {
      print("Error Detail: $e");
    } finally {
      isLoadingDetail(false);
    }
  }
}