// all_article.dart
import 'package:diet_apps/components/article.dart';
import 'package:diet_apps/components/buttom_navigation.dart';
import 'package:diet_apps/components/search.dart';
import 'package:diet_apps/controllers/article_controller.dart'; // Import controller
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllArticle extends StatelessWidget {
  const AllArticle({super.key});

  @override
  Widget build(BuildContext context) {
    // Mencari controller yang sudah aktif
    final ArticleController articleController = Get.find<ArticleController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column( // Gunakan Column agar Search Bar tetap di atas saat scroll
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text("Artikel", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Searching("cari artikel", (value) {
                articleController.fetchAllArticles(query: value);
              }),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (articleController.isLoading.value) {
                  return Column(
                    children: List.generate(10, (index) => ArticleCardSkeleton()),
                  );
                }

                if (articleController.allArticles.isEmpty) {
                  return const Center(child: Text("Tidak ada artikel."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  itemCount: articleController.allArticles.length,
                  itemBuilder: (context, index) {
                    final article = articleController.allArticles[index];
                    return ArticleCard(
                      article.img ?? '', 
                      article.title, 
                      article.date ?? '', 
                      () {
                        Navigator.pushNamed(context, "/details-article", arguments: article.id);
                      }
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}