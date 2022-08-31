import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialogBox{
  information(BuildContext context,String title,String desc,VoidCallback onPressed){
    return showDialog(
      context: context, 
      barrierDismissible: true,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child:  ListBody(children: [Text(desc)],),
          ),
          actions: <Widget>[
            ElevatedButton(onPressed: onPressed, child: Text("Ok"))
          ],
        );
      }
    );
  }
}