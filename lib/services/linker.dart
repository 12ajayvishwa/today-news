import 'package:flutter/material.dart';

import 'package:todaynews/screens/home/dashboard.dart';
import 'package:todaynews/screens/home/home.dart';

import 'package:todaynews/services/firebase/auth_services.dart';

import '../screens/signin_page.dart';

class Linker extends StatefulWidget {
  final AuthClass auth;
  const Linker({Key? key, required this.auth}) : super(key: key);

  @override
  State<Linker> createState() => _LinkerState();
}

// ignore: camel_case_types
enum authStatus { notSignedIn, signedIn }

class _LinkerState extends State<Linker> {
  authStatus _authStatus = authStatus.notSignedIn;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((firebaseUserId) {
      setState(() {
        // ignore: unnecessary_null_comparison
        _authStatus = firebaseUserId == null
            ? authStatus.notSignedIn
            : authStatus.signedIn;
      });
    });
  }

  void signedIn(){
    setState(() {
      _authStatus = authStatus.signedIn;
    });
  }

  void signedOut(){
    setState(() {
      _authStatus = authStatus.notSignedIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    switch(_authStatus){
      case authStatus.notSignedIn:
      return SignInPage(
        auth: widget.auth,
        onSignedIn: signedOut,
        
      );
      
      case authStatus.signedIn:
      return Home(
        auth: widget.auth,
        onSignedOut: signedIn,
      );
    }
  }
}
