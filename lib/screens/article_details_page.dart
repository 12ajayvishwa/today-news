import 'package:flutter/material.dart';

import 'package:todaynews/model/news_article_model.dart';

class ArticleDetailsPage extends StatelessWidget {
  final Article? article;
  const ArticleDetailsPage({Key? key, this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Color.fromARGB(31, 247, 241, 241),
      //   title: Text(
      //     article!.title ?? "",
      //     style: TextStyle(color: Colors.blue, fontFamily: "oswald"),
      //   ),
      //   leading: IconButton(
      //     icon: Icon(
      //       Icons.arrow_back,
      //       color: Colors.blue,
      //       size: 25,
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(children: [
          Positioned(
              child: Container(
            height: 350,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.black12,
                image: DecorationImage(
                    image: NetworkImage(article!.urlToImage ?? ""),
                    fit: BoxFit.cover)),
          )),
          Positioned(
              top: 27,
              left: 10,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.white.withOpacity(0.9)),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )),
          Positioned(
              bottom: 0,
              child: Container(
                height: size.height / 1.7,
                width: size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 15.0, left: 10, right: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article!.title ?? "",
                          style: const TextStyle(
                              fontSize: 20,
                              fontFamily: "oswald",
                              fontWeight: FontWeight.w600),
                        )
                      ]),
                ),
              ))
        ]),
      ),
    );
  }
}
