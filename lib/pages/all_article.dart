import 'package:diet_apps/components/article.dart';
import 'package:diet_apps/components/buttom_navigation.dart';
import 'package:diet_apps/components/search.dart';
import 'package:diet_apps/controllers/article_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllArticle extends StatelessWidget {
  const AllArticle({super.key});

  @override
  Widget build(BuildContext context) {
    final ArticleController articleController = Get.find<ArticleController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
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
              child: RefreshIndicator(
                onRefresh: () => articleController.fetchAllArticles(),
                color: Colors.blueAccent,
                backgroundColor: Colors.white,
                child: Obx(() {
                  // Loading state
                  if (articleController.isLoading.value) {
                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: List.generate(5, (index) => ArticleCardSkeleton()),
                      ),
                    );
                  }

                  // Error state
                  if (articleController.allError.value.isNotEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.cloud_off_rounded, size: 64, color: Colors.red.shade300),
                                const SizedBox(height: 16),
                                Text(
                                  articleController.allError.value,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton.icon(
                                  onPressed: () => articleController.fetchAllArticles(),
                                  icon: const Icon(Icons.refresh_rounded),
                                  label: const Text("Muat Ulang"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  // Empty state
                  if (articleController.allArticles.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade400),
                              const SizedBox(height: 16),
                              Text(
                                "Tidak ada artikel ditemukan",
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  // Success state
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}