import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/article_controller.dart';

class DetailArticlePage extends StatefulWidget {
  const DetailArticlePage({super.key});

  @override
  State<DetailArticlePage> createState() => _DetailArticlePageState();
}

class _DetailArticlePageState extends State<DetailArticlePage> {
  final ArticleController articleController = Get.find<ArticleController>();

  @override
  void initState() {
    super.initState();
    // Menjalankan fetch detail setelah widget pertama kali dibuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Menangkap ID yang dikirim dari arguments
      final int articleId = ModalRoute.of(context)!.settings.arguments as int;
      articleController.getDetailArticle(articleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Artikel")),
      body: Obx(() {
        if (articleController.isLoadingDetail.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final article = articleController.detailArticle.value;

        if (article.id == 0) {
          return const Center(child: Text("Gagal memuat detail artikel"));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Artikel
              Image.network(
                article.img ?? '',
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                    Container(height: 200, color: Colors.grey, child: const Icon(Icons.broken_image)),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.date ?? '',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Divider(height: 30),
                    // ISI KONTEN ARTIKEL
                    Text(
                      article.content ?? 'Isi konten tidak tersedia.',
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}