

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todaynews/model/blog_data_model.dart';

class BlogDataService {

  final _auth = FirebaseAuth.instance;


  postBlogToFirestore(String authorName, String desc, String title,
      String imageUrl, BuildContext context) async {
        FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

        User? user = _auth.currentUser;

        BlogModel blogModel = BlogModel();

        blogModel.authorName = authorName;
        blogModel.title = title;
        blogModel.desc = authorName;
        blogModel.url = blogModel.url;

        await firebaseFirestore.collection("blogs").doc(user!.uid).set(blogModel.blogMap());


        Fluttertoast.showToast(msg: "Submitted succesfully");

        Navigator.pop(context);

      } 
}
