import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart';
import 'package:todaynews/widgets/custom_appbar.dart';

import '../../../widgets/logo_text.dart';

class FavouriteBLog extends StatefulWidget {
  const FavouriteBLog({Key? key}) : super(key: key);

  @override
  State<FavouriteBLog> createState() => _FavouriteBLogState();
}

class _FavouriteBLogState extends State<FavouriteBLog> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
      backgroundColor: Color.fromARGB(94, 255, 254, 254),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.grey,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text('Favourite Blogs',style: TextStyle(color: Colors.black,fontFamily: "Lato"),),
      centerTitle: true,
    ),
    body: Center(child:
     
        Text("You didn't added favourite blog",style: TextStyle(fontFamily: "Lato",fontSize: 25),)
    ))   ;
  }
}
