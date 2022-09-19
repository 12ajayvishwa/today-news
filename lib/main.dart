import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:todaynews/screens/user_auth/signin_page.dart';
import 'package:todaynews/screens/user_auth/signup_page.dart';
import 'package:todaynews/screens/profile_page/user_profile_page.dart';
import 'package:todaynews/services/firebase/auth_services.dart';
import 'package:todaynews/services/linker.dart';

import 'screens/home/components/home.dart';



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
