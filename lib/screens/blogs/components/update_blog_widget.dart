import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todaynews/services/firebase/firebase_function.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/input_form_field.dart';

FirebaseFunction firebaseFunction = FirebaseFunction();
FirebaseAuth auth = FirebaseAuth.instance;

getDescEdited(String id, BuildContext context,VoidCallback onPressed,[DocumentSnapshot? documentSnapshot]) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            child: Container(
              alignment: Alignment.center,
              height: 150,
              width: 300,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(25)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomButton(
                      color: Colors.red,
                      text: "Delete This Blog",
                      onPressed: () => firebaseFunction.deleteBlog(id,context),
                      radius: BorderRadius.circular(12),
                      size: MediaQuery.of(context).size),
                  CustomButton(
                      color: Colors.greenAccent,
                      text: "Edit This Blog",
                      onPressed: onPressed,
                      radius: BorderRadius.circular(12),
                      size: MediaQuery.of(context).size),
                ],
              ),
            ),
          );
        });
  }

