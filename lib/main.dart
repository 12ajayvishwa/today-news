import 'package:flutter/material.dart';

void main() {
  print("hey there");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Today News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(child: Text("Hey there"),)
    );
  }
}
