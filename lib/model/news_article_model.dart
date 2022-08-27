import 'package:todaynews/model/news_source_model.dart';

class Article {
  NewsSource? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishAt;
  String? content;

  Article(
      {this.source,
      this.author,
      this.title,
      this.description,
      this.content,
      this.publishAt,
      this.url,
      this.urlToImage});

  factory Article.fromJson(Map<String,dynamic> json){
    return Article(
      source: NewsSource.fromJson(json['source']),
      author: json['author'] ?? "",
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      url: json['url'] ?? "",
      urlToImage: json['urlToImage'] ?? "",
      publishAt: json['publishAt'] ?? "",
      content: json['content'] ?? ""
    );
  }
}
