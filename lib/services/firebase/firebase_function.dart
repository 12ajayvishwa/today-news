import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todaynews/services/firebase/storage_method.dart';
import 'package:uuid/uuid.dart';
import '../../model/blog_data_model.dart';

class FirebaseFunction {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadBlog(BuildContext context,
      String authorName, String title, String desc, File image,String uid) async {
    try {
      String postId = Uuid().v1();
      DateTime time = DateTime.now();
      String imageUrl = await StorageMethods().uploadImageToStorage('post', image, true);

      Blog blog = Blog(
        authorName: authorName,
        title: title,
        desc: desc,
        postUrl: image,
        uid: uid,
        likes: [],
        blogId: postId,
        time: time,
      );

      _firestore.collection('blogs').doc(postId).set(blog.toJson());
      Fluttertoast.showToast(msg: "Blog Uploaded Success");
    }catch (e){
      Fluttertoast.showToast(msg: "Something went wrong");
    }
    return "";
      }

  // Future<String> uploadImage(File file) async {
  //   try {
  //     String imageName = Uuid().v1();

  //     var refrence = _storage.ref().child("/file").child("/$imageName.jpg");
  //     var uploadTask = await refrence.putFile(file);
  //     String url = await uploadTask.ref.getDownloadURL();

  //     return url;
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: "$e");
  //     return "";
  //   }
  // }

  // Future<List> getBlogs() async {
  //   if (_hasMoreData) {
  //     if (!isLoading.value) {
  //       try {
  //         if (_lastDocument == null) {
  //           return await _firebaseFirestore
  //               .collection('blogs')
  //               .orderBy('time')
  //               .limit(_documentLimit)
  //               .get()
  //               .then((value) {
  //             _lastDocument = value.docs.last;

  //             if (value.docs.length < _documentLimit) {
  //               _hasMoreData = false;
  //             }

  //             return value.docs
  //                 .map((e) => BlogModel.fromJson(e.data()))
  //                 .toList();
  //           });
  //         } else {
  //           isLoading.value = true;

  //           return await _firebaseFirestore
  //               .collection("blogs")
  //               .orderBy('time')
  //               .startAfterDocument(_lastDocument!)
  //               .limit(_documentLimit)
  //               .get()
  //               .then((value) {
  //             _lastDocument = value.docs.last;

  //             if (value.docs.length < _documentLimit) {
  //               _hasMoreData = false;
  //             }

  //             isLoading.value = false;

  //             return value.docs
  //                 .map((e) => BlogModel.fromJson(e.data()))
  //                 .toList();
  //           });
  //         }
  //       } catch (e) {
  //         Fluttertoast.showToast(msg: "$e");
  //         print(e.toString());
  //         return [];
  //       }
  //     } else {
  //       return [];
  //     }
  //   } else {
  //     print("No More Data");
  //     return [];
  //   }
  // }

  // Future<void> saveDataToMyBlogs(String id) async {
  //   try {
  //     await _firebaseFirestore
  //         .collection('users')
  //         .doc(_auth.currentUser!.uid)
  //         .collection('myBlogs')
  //         .doc(id)
  //         .set({'id': id});
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: "$e");
  //   }
  // }

  // Future<List> getMyBlogs() async {
  //   try {
  //     var snapshot = await _firebaseFirestore
  //         .collection('users')
  //         .doc(_auth.currentUser!.uid)
  //         .collection("myBlogs")
  //         .get();
  //     return snapshot.docs.map((e) => e.data()['id']).toList();
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: "$e");
  //     return [];
  //   }
  // }

  // Future<BlogModel> getBlogsById(String id) async {
  //   try {
  //     var documentSnapshot =
  //         await _firebaseFirestore.collection('blogs').doc(id).get();

  //     return BlogModel.fromJson(documentSnapshot.data()!);
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: "$e");
  //     return BlogModel(
  //         authorName: "",
  //         time: "",
  //         date: "",
  //         desc: "",
  //         title: "",
  //         id: "",
  //         url: "");
  //   }
  // }

  // Future<void> deletePublicBlog(String id) async {
  //   try {
  //     await _firebaseFirestore.collection('blogs').doc(id).delete();
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: "$e");
  //   }
  // }

  // Future<void> deleteMyBlog(String id) async {
  //   try {
  //     await _firebaseFirestore
  //         .collection('blogs')
  //         .doc(_auth.currentUser!.uid)
  //         .collection('myBlogs')
  //         .doc(id)
  //         .delete();
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: "$e");
  //   }
  // }

  Future<void> editBlog(
      String id, Map<String, dynamic> map, BuildContext context) async {
    try {
      await _firestore.collection('blogs').doc().update(map);
      Fluttertoast.showToast(msg: "blog updated sucessfully");
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
      print(e.toString());
      Navigator.pop(context);
    }
  }

  // Future<void> addToFavourite(String id) async {
  //   try {
  //     await _firebaseFirestore
  //         .collection('users')
  //         .doc(_auth.currentUser!.uid)
  //         .collection('favourite')
  //         .doc(id)
  //         .set({'id': id});
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: "$e");
  //   }
  // }

  // Future<List> getFavouriteList() async {
  //   try {
  //     var querySnapshot = await _firebaseFirestore
  //         .collection('users')
  //         .doc(_auth.currentUser!.uid)
  //         .collection('favourite')
  //         .get();

  //     return querySnapshot.docs.map((e) => e.data()['id']).toList();
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: "$e");
  //     return [];
  //   }
  // }

  // Future<void> deleteFromFavourite(String id) async {
  //   try {
  //     await _firebaseFirestore
  //         .collection('users')
  //         .doc(_auth.currentUser!.uid)
  //         .collection('favourite')
  //         .doc(id)
  //         .delete();
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: "$e");
  //   }
  // }
      
  Future<void> deleteBlog(String id, BuildContext context) async {
    final CollectionReference ref =
        FirebaseFirestore.instance.collection('blogs');
    try {
      await ref.doc(id).delete();
      Fluttertoast.showToast(msg: "You have sucessfully deleted a Blog");
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  
  }

  Future<String> likePost(String postId,String uid,List Likes) async {
    String res = "Some error found";

    try{
      if(Likes.contains(uid)){
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('blogs').doc(postId).update({'likes':FieldValue.arrayRemove([uid])});

      }else{
        // else we need to add uid to the likes array
        _firestore.collection('blogs').doc(postId).update({
          'likes':FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    }catch(e){
      res = e.toString();
    }
    return res;
  }
}
