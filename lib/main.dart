import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todaynews/services/linker.dart';

 



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // ignore: avoid_print
  print("initialized");
  runApp( const MyApp());
    
  //   ScreenUtilInit(
  //   designSize: Size(360, 690),
  //   builder: (context, child) {
  //     return GetMaterialApp(
  //       debugShowCheckedModeBanner: false,
  //       title: "Blog-App",
  //       initialRoute: AppPages.INITIAL,
  //       getPages: AppPages.routes,
  //     );
  //   },
  // ));
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
      home:Linker()
    );
  }
}
