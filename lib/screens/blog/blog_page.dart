import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todaynews/screens/blog/blog_details_page.dart';
import 'package:todaynews/screens/home/dashboard.dart';
import 'package:todaynews/screens/home/home.dart';
import 'package:todaynews/utils/style/text_style.dart';
import '../../model/blog_data_model.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key}) : super(key: key);

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  List<Blog> blogList = [];
  bool isLoading = false;
  bool isLiked = false;
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
    String descEdited = await getDescEdited(blog.desc ?? "");
    if(descEdited != null) {
      blog.desc = descEdited;
    }
    blogsRef.child(blog.blogKey!).update(blog.toJson()).then((_) {
      print("Update Post with ID :" + blog.blogKey!);
      setState(() {
        blogList[index].desc = blog.desc;
      });
      
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

//  Future<void> refreshBlogs() async {
//   blogsRef.once().then((DatabaseEvent event){
//     var blogKey = event.snapshot.keys;
//     var b
//   })

  
//   }

  @override
  void initState() {
    super.initState();
   
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color.fromARGB(31, 247, 241, 241),
              title: const Text(
                "Feed",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: "oswald",
                    fontWeight: FontWeight.w500),
              ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => Home()));
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                  )),
              centerTitle: true,
            ),
      body:
      
      FirebaseAnimatedList(
          query: blogsRef, 
          itemBuilder: (context, snapshot, animation, index) {
            Map blogs = snapshot.value as Map;
            blogs['key'] = snapshot.key;
            return blogCard(blogs: blogs,context: context,blog: blogs[index]);
          })
    );
  }

  Widget blogCard({required Map blogs ,required BuildContext context,Blog? blog}){
    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => BlogDetailsPage(blog: blog,)));
      },
      child: Container(
        margin:const EdgeInsets.all(12.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3.0)]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date : "+blogs['date'],textAlign: TextAlign.center,),
                Text("Time : "+blogs['time'],textAlign: TextAlign.center,),
                DropdownButton(
                  icon: Icon(Icons.more_vert),
                  items: <String>['Edit','Delete']
                  .map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value));
                  }).toList(),
                  onChanged: (String? value){
                    // if(value == 'Delete'){
                    //   deletePost(blog, index);
                    // }else if (value == 'Edit'){
                    //   updateBlog(blog, index);
                    // }
                  })
              ],
            ),
            const SizedBox(
              height:10
            ),
            Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(blogs['image']),
                    fit: BoxFit.fitWidth),
                borderRadius: BorderRadius.circular(12.0)),
          ),
          SizedBox(height: 8,),
           Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(30.0)),
            child: Text("Author : " + blogs['authorName'],
              
              style: const TextStyle(color: Colors.white),
            ),
          ),
            
            SizedBox(height: 10,),
            Text(blogs['desc'],
            softWrap: true,
            textAlign: TextAlign.center,style: textStyle(),),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child:Row(children: [
                    IconButton(icon: Icon(isLiked ?
                    Icons.favorite:Icons.favorite_outline,color: isLiked?Colors.red:Colors.grey), onPressed: () { 
                      setState(() {
                        isLiked = !isLiked;
                      });
                     },),
                    Text("Like")
                  ],),
                ),
                Container(
                  child:Row(children: [
                    IconButton(icon: Icon(Icons.comment_outlined,color: Colors.grey,), onPressed: () { 
                      
                     },),
                    Text("Reply")
                  ],),
                )
                
              ],
              
            ),

          ],
        ),
      ),
    );
  }
  
}