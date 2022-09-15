// ignore_for_file: deprecated_member_use
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todaynews/screens/blogs/components/blog_details_page.dart';
import 'package:todaynews/screens/home/home.dart';
import 'package:todaynews/services/firebase/firebase_function.dart';
import 'package:todaynews/utils/style/text_style.dart';
import '../../../model/blog_data_model.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/input_form_field.dart';
import '../components/update_blog_widget.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key}) : super(key: key);

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  String? refresh;
  CollectionReference? postRef;
  DocumentReference? likeRef;
  String? uid;
  int count = 0;
  bool isLiked = false;
  Map<String, dynamic>? data;
  DocumentSnapshot? ds;

  @override
  void initState() {
    likeRef = FirebaseFirestore.instance.collection('likes').doc(uid);
    super.initState();
    likeRef!.get().then((value) => data = value.data as Map<String, dynamic>?);
    postRef = FirebaseFirestore.instance.collection('blogs');
  }

  isLikedFunc(){
    setState(() {
      isLiked = true;
    });
    if(isLiked){
      Timer(Duration(milliseconds: 500),(){
        setState(() {
          isLiked = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('data $data');
    return Scaffold(
        appBar: feedAppBar(context),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('blogs')
                .orderBy('id')
                .snapshots(),
            builder: ((context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              
              if (streamSnapshot.hasData) {
                final blogs = streamSnapshot.data!.docs;
                switch (streamSnapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  default:
                    return blogListView(blogs, streamSnapshot, context);
                }
                // return blogListView(blogs, streamSnapshot, context);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              // return const Center(
              //   child: CircularProgressIndicator(),
              // );
            }),
            ));
  }

  ListView blogListView(
      List<QueryDocumentSnapshot<Object?>> blogs,
      AsyncSnapshot<QuerySnapshot<Object?>> streamSnapshot,
      BuildContext context) {
    return ListView.builder(
        itemCount: blogs.length,
        itemBuilder: (_, index) {
          final DocumentSnapshot documentSnapshot =
              streamSnapshot.data!.docs[index];
          return InkWell(
            onTap: () {
              WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => BlogDetailsPage(blogs: blogs))));




              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => BlogDetailsPage(blogs: blogs)));
            },
            child: Container(
              margin: const EdgeInsets.all(12.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.0),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 3.0)
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        documentSnapshot['date'] ?? "",
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      Text(
                        documentSnapshot['time'] ?? "",
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      IconButton(
                          onPressed: () {
                            getDescEdited(documentSnapshot['id'], context, () {
                              updateBlog(context);
                            }, documentSnapshot);
                          },
                          icon: const Icon(Icons.more_vert))
                    ],
                  ),
                  const SizedBox(height: 10),
                  Stack(
                    alignment: Alignment.center,
                    children: [InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => BlogDetailsPage(blogs: blogs)));
                      },
                      onDoubleTap: () {
                        isLikedFunc();
                        // String uid = streamSnapshot.data!.docs[index]['uid'];

                        // print('likeRef not null $likeRef');
                        // likeRef!.get().then((value) => {
                        //   if(value.data != null){
                        //     if(value.data.keys.contains(uid)){
                        //       FirebaseFirestore.instance.
                        // }
                        //   }
                        // });
                      },
                      child: Container(
                        height: 200.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: documentSnapshot['url'] == null
                                    ? const NetworkImage(
                                        "https://img.freepik.com/free-vector/no-data-concept-illustration_114360-2506.jpg?w=740&t=st=1662625292~exp=1662625892~hmac=9461f11097496c9db0e8fbc9f8441cd24b4f85bdb8df6b128f98257ccda67e78")
                                    : NetworkImage(documentSnapshot['url'] ?? ""),
                                fit: BoxFit.fitWidth),
                            borderRadius: BorderRadius.circular(12.0)),
                      ),
                    ),
                    isLiked?Align(
                      alignment: Alignment.center,
                      child: Container(
                      child: Icon(Icons.favorite,color: Colors.white60,size: 80,),),
                    ):Container()
                    ]
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30.0)),
                    // ignore: prefer_interpolation_to_compose_strings
                    child: Text(
                      // ignore: prefer_interpolation_to_compose_strings
                      "Author : " + documentSnapshot['authorName'],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    documentSnapshot['desc'],
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: textStyle(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          data != null &&
                                  data!.containsKey(
                                      streamSnapshot.data!.docs[index]['id'])
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 25,
                                )
                              : const Icon(
                                Icons.favorite_border_outlined,color: Colors.grey,size: 25,
                              ),
                              
                              
                              
                              
                              // IconButton(
                              //     icon: const Icon(
                              //       Icons.favorite_border,
                              //       size: 28.0,
                              //       color: Colors.grey,
                              //     ),
                              //     onPressed: () {},
                              //   ),
                          // Text('${streamSnapshot.data!.docs[index]['likes']}',style: TextStyle(color: Colors.black),)
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.comment_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () {},
                          ),
                          const Text("Reply")
                        ],
                      )
                    ],
                  ),
                  // Text(blog!.like!.length.toString())
                ],
              ),
            ),
          );
        });
  }

  AppBar feedAppBar(BuildContext context) {
    return AppBar(
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
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const Home()));
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.grey,
          )),
      centerTitle: true,
    );
  }

  void updateBlog(BuildContext context,
      [DocumentSnapshot? documentSnapshot]) async {
    TextEditingController descEditingController = TextEditingController();
    await showModalBottomSheet(
        backgroundColor: Color.fromARGB(255, 235, 229, 229),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DescriptionField(
                  controller: descEditingController,
                  hintText: "Description...",
                  size: MediaQuery.of(context).size,
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  labelText: "Description",
                ),
                CustomButton(
                    color: Colors.blue,
                    text: "Update",
                    onPressed: () async {
                      firebaseFunction.editBlog(documentSnapshot!.id,
                          {'desc': descEditingController.text}, context);
                    },
                    radius: BorderRadius.circular(12),
                    size: MediaQuery.of(context).size)
              ],
            ),
          );
        });
  }
}
