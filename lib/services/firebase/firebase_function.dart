import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:todaynews/model/blog_data_model.dart';
import 'package:uuid/uuid.dart';
import '../../utils/indicator.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/input_form_field.dart';

class FirebaseFunction {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool _hasMoreData = true;
  DocumentSnapshot? _lastDocument;
  int _documentLimit = 5;
  var isLoading = false.obs;

  Future<void> createUserCredential(
      String name, String email, String address, String phoneNumber) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({
        'uid': _auth.currentUser!.uid,
        "name": name,
        "email": email,
        "addrss": address,
        "phoneNumber": phoneNumber
      }).then((value) {
        Indicator.closeLoading();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> uploadBlog(
      String authorName, String title, String desc, File image) async {
    try {
      String id = Uuid().v1();
      DateTime time = DateTime.now();
      String imageUrl = await uploadImage(image);

      Map<String, dynamic> blogDetails = {
        'id': id,
        'title': title,
        'authorName': authorName,
        'desc': desc,
        'url': imageUrl,
        'time': time
      };
      await _firebaseFirestore
          .collection('blogs')
          .doc(id)
          .set(blogDetails)
          .then((value) {
        saveDataToMyBlogs(id);
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
    }
  }

  Future<String> uploadImage(File file) async {
    try {
      String imageName = Uuid().v1();

      var refrence = _storage.ref().child("/file").child("/$imageName.jpg");
      var uploadTask = await refrence.putFile(file);
      String url = await uploadTask.ref.getDownloadURL();

      return url;
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
      return "";
    }
  }

  Future<List> getBlogs() async {
    if (_hasMoreData) {
      if (!isLoading.value) {
        try {
          if (_lastDocument == null) {
            return await _firebaseFirestore
                .collection('blogs')
                .orderBy('time')
                .limit(_documentLimit)
                .get()
                .then((value) {
              _lastDocument = value.docs.last;

              if (value.docs.length < _documentLimit) {
                _hasMoreData = false;
              }

              return value.docs
                  .map((e) => BlogModel.fromJson(e.data()))
                  .toList();
            });
          } else {
            isLoading.value = true;

            return await _firebaseFirestore
                .collection("blogs")
                .orderBy('time')
                .startAfterDocument(_lastDocument!)
                .limit(_documentLimit)
                .get()
                .then((value) {
              _lastDocument = value.docs.last;

              if (value.docs.length < _documentLimit) {
                _hasMoreData = false;
              }

              isLoading.value = false;

              return value.docs
                  .map((e) => BlogModel.fromJson(e.data()))
                  .toList();
            });
          }
        } catch (e) {
          Fluttertoast.showToast(msg: "$e");
          print(e.toString());
          return [];
        }
      } else {
        return [];
      }
    } else {
      print("No More Data");
      return [];
    }
  }

  Future<void> saveDataToMyBlogs(String id) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('myBlogs')
          .doc(id)
          .set({'id': id});
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
    }
  }

  Future<List> getMyBlogs() async {
    try {
      var snapshot = await _firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection("myBlogs")
          .get();
      return snapshot.docs.map((e) => e.data()['id']).toList();
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
      return [];
    }
  }

  Future<BlogModel> getBlogsById(String id) async {
    try {
      var documentSnapshot =
          await _firebaseFirestore.collection('blogs').doc(id).get();

      return BlogModel.fromJson(documentSnapshot.data()!);
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
      return BlogModel(
          authorName: "",
          time: "",
          date: "",
          desc: "",
          title: "",
          id: "",
          url: "");
    }
  }

  Future<void> deletePublicBlog(String id) async {
    try {
      await _firebaseFirestore.collection('blogs').doc(id).delete();
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
    }
  }

  Future<void> deleteMyBlog(String id) async {
    try {
      await _firebaseFirestore
          .collection('blogs')
          .doc(_auth.currentUser!.uid)
          .collection('myBlogs')
          .doc(id)
          .delete();
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
    }
  }

  Future<void> editBlog(
      String id, Map<String, dynamic> map, BuildContext context) async {
    try {
      await _firebaseFirestore.collection('blogs').doc().update(map);
      Fluttertoast.showToast(msg: "blog updated sucessfully");
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
      print(e.toString());
      Navigator.pop(context);
    }
  }

  Future<void> addToFavourite(String id) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('favourite')
          .doc(id)
          .set({'id': id});
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
    }
  }

  Future<List> getFavouriteList() async {
    try {
      var querySnapshot = await _firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('favourite')
          .get();

      return querySnapshot.docs.map((e) => e.data()['id']).toList();
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
      return [];
    }
  }

  Future<void> deleteFromFavourite(String id) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('favourite')
          .doc(id)
          .delete();
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
    }
  }

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
}
