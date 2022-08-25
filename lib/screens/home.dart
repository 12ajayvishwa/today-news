import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todaynews/screens/signup_page.dart';

import 'phone_verification_page.dart';
import 'signin_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Hello programmer :)"),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        await _auth.signOut();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInPage()));
      },
      child: Icon(Icons.logout),),
    );
  }
}