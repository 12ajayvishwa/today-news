import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {
  String? authorName;
  String? uid;
  String? title;
  String? desc;
  dynamic likes;
  DateTime? date;
  DateTime? time;
  File? postUrl;
  File? profileImg;
  String? blogId;

  Blog(
      {this.authorName,
      this.uid,
      this.title,
      this.desc,
      this.likes,
      this.postUrl,
      this.date,
      this.time,
      this.blogId,
      this.profileImg});

  //sending data to blog collection

  static Blog fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Blog(
        authorName: snapshot['authorName'],
        uid: snapshot['uid'],
        title: snapshot['title'],
        desc: snapshot['desc'],
        likes: snapshot['Likes'],
        postUrl: snapshot['postUrl'],
        blogId: snapshot['blogId'],
        profileImg: snapshot['profileImage']);
  }

  Map<String,dynamic> toJson() => {
    "authorName": authorName ?? "",
    "uid":uid ?? "",
    "title":title ?? "",
    "desc" : desc ??"",
    "likes": likes ?? "",
    "postUrl":postUrl?? "",
    "blogId" : blogId ?? "",
    "profileImg":profileImg ?? ""
  };

  // Map<String, dynamic> blogMap() {
  //   return {
  //     "imageUrl": postUrl ?? "",
  //     "authorName": authorName ?? "",
  //     "title": title ?? "",
  //     "desc": desc ?? "",
  //   };
  // }

  // toJson() {
  //   return {
  //     'imageUrl': postUrl ?? "",
  //     'authorName': authorName ?? "",
  //     'title': title ?? "",
  //     'desc': desc ?? "",
  //     'time': time ?? "",
  //     'date': date ?? "",
  //   };
  // }

  // Blog.fromJson(Map<String, dynamic> map) {
  //   uid = map['id'];
  //   authorName = map['authorName'];
  //   title = map['title'];
  //   desc = map['desc'];
  //   postUrl = map['imageUrl'];
  // }
}
