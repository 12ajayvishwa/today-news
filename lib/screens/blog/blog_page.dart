import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todaynews/widgets/custom_appbar.dart';

import '../../model/blog_data_model.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key}) : super(key: key);

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  List<Blog> blogList = [];
  bool isLoading = false;
  DatabaseReference blogsRef = FirebaseDatabase.instance.ref().child("blogs");

  Future getDescEdited(String desc) async {
    TextEditingController descEditingController = TextEditingController(text: desc,);

    await showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  controller: descEditingController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Edit Caption',
                  ),
                ))
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              FlatButton(
                  child: Text('Save'),
                  onPressed: () {
                    desc = descEditingController.text.toString();
                    Navigator.pop(context);
                  })
            ],
        );
      });

      return desc;
  }

  void updateBlog(Blog blog, int index) async {
    String descEdited = await getDescEdited(blog.desc!);
    if(descEdited != null) {
      blog.desc = descEdited;
    }
    blogsRef.child(blog.blogKey!).update(blog.toJson()).then((_) {
      setState(() {
        
      });
      print("Update Post with ID :" + blog.blogKey!);
    });
  }

  void deletePost(Blog blog, int index){
    blogsRef.child(blog.blogKey!).remove().then((_){
      print("Deleted Post with ID : " + blog.blogKey!);
      setState(() {
        blogList.removeAt(index);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(child: Text("data"),),
    );
  }
}