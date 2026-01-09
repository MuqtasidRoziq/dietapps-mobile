class ArticleModel {
  final int id;
  final String title;
  final String? summary;
  final String? content;
  final String? img;
  final String? date;

  ArticleModel({
    required this.id,
    required this.title,
    this.summary,
    this.content,
    this.img,
    this.date,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'],
      title: json['title'],
      summary: json['summary'],
      content: json['content'], // Muncul di route detail
      // Menangani image_url (dari /home) atau image (dari /api/articles)
      img: json['image_url'] ?? json['image'], 
      // Menangani published_at (dari /home) atau date (dari /api/articles)
      date: json['published_at'] ?? json['date'],
    );
  }
}