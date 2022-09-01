import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:todaynews/model/user_data.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {

  UserModel userModel = UserModel();
  String _userName = "";

  Future<void> _getUserDetails() async {
    FirebaseFirestore.instance.collection('users')
    .doc((await FirebaseAuth.instance.currentUser!()).uid)
    .get()
    .then((value) {
      setState(() {
        _userName = value.data['name'].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      body: Container(
        padding: EdgeInsets.all(12),
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(height: size.height*0.1,),
            Container(
              height: size.height*0.25,
              width: size.width*0.25,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue,width: 2),
                image: DecorationImage(image: NetworkImage("https://icons.veryicon.com/png/o/internet--web/prejudice/user-128.png"),fit: BoxFit.contain)
              ),
              ),
            Text(userModel.name!)
          ],
        ))
    );
  }
}