import 'package:flutter/material.dart';
import 'package:todaynews/model/news_article_model.dart';
import 'package:todaynews/screens/article_page/article_details_page.dart';

Widget custtomListTile(Article article, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ArticleDetailsPage(
                    article: article,
                  )));
    },
    child: Container(
      margin:const EdgeInsets.all(12.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.0),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3.0)]),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(article.urlToImage!),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(12.0)),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(30.0)),
              child: Text(
                article.source!.name ?? "",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              article.title!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            )
          ]),
    ),
  );
}
