import 'package:flutter/material.dart';
import '../../model/blog_data_model.dart';

class BlogDetailsPage extends StatelessWidget {
  final Blog? blog;
  const BlogDetailsPage({required this.blog,});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                    image: NetworkImage(blog!.url ?? ""),
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
                    color: Colors.black12.withOpacity(0.2)),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
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
                        
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
blog!.title ??"",
                          style: const TextStyle(
                              fontSize: 20,
                              fontFamily: "oswald",
                              fontWeight: FontWeight.w300),
                        ),
                        SizedBox(height: 25,),
                        Text(blog!.desc ?? "",style: const TextStyle(
                              fontSize: 15,
                              fontFamily: "oswald",
                              ),)
                      ]),
                ),
              )),
        ]),
      ),
    ) ;
  }
}