import 'dart:convert';
import 'package:http/http.dart';
import 'package:todaynews/model/news_article_model.dart';

class ApiServices {
  final endPointUrl =
      "https://newsapi.org/v2/top-headlines?country=in&apiKey=000e697ec62d4f4184f318f61b8693a0";


  Future<List<Article>> getArticle() async {
    Response res = await get(Uri.parse(endPointUrl));

    if(res.statusCode == 200){
      Map<String,dynamic> json = jsonDecode(res.body);

      List<dynamic> body = json['articles'];


      List<Article> articles = body.map((dynamic item) => Article.fromJson(item)).toList();

      return articles;
    } else {
      throw ("Can't get the Article");
    }
  }
}
