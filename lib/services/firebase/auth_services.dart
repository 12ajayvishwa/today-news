import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todaynews/model/user_data.dart';
import 'package:todaynews/screens/user_auth/signin_page.dart';
import '../../screens/home/components/home.dart';

class AuthClass {
  final _auth = FirebaseAuth.instance;

  Future<void> signUp(String email, String password, String name,
      String address, String phoneNumber, BuildContext context) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                postDetailsToFirestore(
                  name,
                  phoneNumber,
                  address,
                  context,
                )
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    } catch (signUpError) {
      if (signUpError is PlatformException) {
        if (signUpError.code == "email already in use") ;
      }
    }
  }


  postDetailsToFirestore(String name, String phoneNumber, String address,
      BuildContext context) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values

    userModel.name = name;
    userModel.uid = user!.uid;
    userModel.email = user.email;
    userModel.address = address;
    userModel.phoneNumber = phoneNumber;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully :) ")));
    // ignore: use_build_context_synchronously
  }
  Future<void> signIn(
      String email, String password, BuildContext context) async {
    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((uid) => {
              Fluttertoast.showToast(msg: "Login Successfull :) "),
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const Home()))
            })
        .catchError((e) {
      Fluttertoast.showToast(msg: e!.message);
    });
  }
  Future<void> forgotPassword(String email, BuildContext context) async {
    await _auth
        .sendPasswordResetEmail(email: email)
        .then((value) => {
              Fluttertoast.showToast(
                  msg: "Email sended successfully\ncheck your email."),
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const SignInPage()))
            })
        .catchError((e) {
      Fluttertoast.showToast(msg: e!.message);
    });
  }
}
