// ignore_for_file: deprecated_member_use



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todaynews/screens/blogs/components/blog_details_page.dart';
import 'package:todaynews/screens/blogs/components/comment.dart';
import 'package:todaynews/screens/home/components/home.dart';
import 'package:todaynews/services/firebase/firebase_function.dart';
import 'package:todaynews/utils/style/text_style.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/input_form_field.dart';
import '../components/update_blog_widget.dart';

class BlogPage extends StatefulWidget {
  final snap;
  BlogPage({required this.snap});
  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final blogRef = FirebaseFirestore.instance.collection("blogs");
  final userRef = FirebaseFirestore.instance.collection("users");
  final DateTime timestamp = DateTime.now();
  int likeCount = 0;
  Map? likes;
  bool isliked = false;

  int getLikeCount(likes) {
    if (likes == null) {
      return 0;
    }
    int count = 0;
    likes.value.forEach((val) {
      if (val == true) {
        count = count + 1;
      }
    });
    return count;
  }

  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: feedAppBar(context),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('blogs')
              .orderBy('date',descending: true)
              .snapshots(),
          builder: ((context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              final blogs = streamSnapshot.data!.docs;
              switch (streamSnapshot.connectionState) {
                case ConnectionState.waiting:
                default:
                  return blogListView(blogs, streamSnapshot, context);
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
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
              WidgetsBinding.instance.addPostFrameCallback((_) =>
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlogDetailsPage(blogs: blogs))));
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
                  Stack(alignment: Alignment.center, children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BlogDetailsPage(blogs: blogs)));
                      },
                      onDoubleTap: () {
                        setState(() {
                          isliked = !isliked;
                          likeCount = likeCount+1;
                        });
                      },
                      child: Container(
                        height: 200.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: documentSnapshot['url'] == null
                                    ? const NetworkImage(
                                        "https://img.freepik.com/free-vector/no-data-concept-illustration_114360-2506.jpg?w=740&t=st=1662625292~exp=1662625892~hmac=9461f11097496c9db0e8fbc9f8441cd24b4f85bdb8df6b128f98257ccda67e78")
                                    : NetworkImage(
                                        documentSnapshot['url'] ?? ""),
                                fit: BoxFit.fitWidth),
                            borderRadius: BorderRadius.circular(12.0)),
                      ),
                    ),
                  ]),
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
                        children:  [
                          likeCount == 0?
                          IconButton(
                            onPressed: (){
                              // FirebaseFunction().likePost(
                              //   widget.snap['blogId'].toString(), 
                              //   FirebaseAuth.instance.currentUser!.uid, 
                              //   widget.snap['likes']);
                              setState(() {
                                likeCount = likeCount++;
                              });
                            },
                            icon: Icon(
                              Icons.favorite_border_outlined,
                              color: Colors.grey,
                              size: 25,
                            ),
                          ):IconButton(
                            onPressed: (){
                              // FirebaseFunction().likePost(
                              //   widget.snap['blogId'].toString(), 
                              //   FirebaseAuth.instance.currentUser!.uid, 
                              //   widget.snap['likes']);
                              setState(() {
                                likeCount = likeCount--;
                              });
                            },
                            icon: Icon(
                              Icons.favorite_border_outlined,
                              color: Colors.red,
                              size: 25,
                            ),
                          ),
                          Text("${likeCount} Likes")
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.comment_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => Comments()));
                            },
                          ),
                          const Text("Reply")
                        ],
                      )
                    ],
                  ),
                  
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
