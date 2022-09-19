import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  const Comments({Key? key}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
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
      title: Text('Comments',style: TextStyle(color: Colors.black,fontFamily: "Lato"),),
      centerTitle: true,
    ),
    body: Center(child:
     
        Text("No Comment!",style: TextStyle(fontFamily: "Lato",fontSize: 25),)
    ))   ;
  }
}
