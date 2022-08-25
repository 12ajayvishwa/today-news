import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todaynews/screens/signup_page.dart';
import 'screens/phone_verification_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print("initialized");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Today News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PhoneVerificationPage()
    );
  }
}
