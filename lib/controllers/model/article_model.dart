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
      content: json['content'],
      img: json['image_url'] ?? json['image'], 
      date: json['published_at'] ?? json['date'],
    );
  }
}