import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:todaynews/screens/home/dashboard.dart';
import 'package:todaynews/screens/user_profile_page.dart';
import 'package:todaynews/services/firebase/auth_services.dart';
import 'dart:io';
import '../blogs/body/blog_page.dart';
import '../blogs/components/add_blog_page.dart';

class Home extends StatefulWidget {
  final AuthClass? auth;
  final VoidCallback? onSignedOut;
  const Home({Key? key, this.auth, this.onSignedOut}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final desController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  File? imageUrl;
  int currentIndex = 0;

  Future imgFromGallery() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageUrl = File(pickedFile.path);
        uploadFile();
      }
    });
  }

  Future uploadFile() async {
    if (imageUrl == null) return;
    final filename = basename(imageUrl!.path);
    final destination = 'files/$filename';

    try {
      final ref = FirebaseStorage.instance.ref(destination).child('file/');
      await ref.putFile(imageUrl!);
    } catch (e) {
      // ignore: avoid_print
      print("error occured");
    }
  }

  final List<Widget> pages = [
    const Dashboard(),
    const BlogPage(),
    const UserProfilePage()
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const Dashboard();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: bucket, child: currentScreen),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF38B6FF),
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AddBlogPage()));
          }),
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = const Dashboard();
                      currentIndex = 0;
                    });
                  },
                  child: tabItems("News", "assets/news.png", 0, context),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = const BlogPage();
                      currentIndex = 1;
                    });
                  },
                  child: tabItems("Blog", "assets/blogging.png", 1, context),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = const UserProfilePage();
                      currentIndex = 2;
                    });
                  },
                  child:
                      tabItems("User profiel", "assets/user1.png", 2, context),
                )
              ],
            ),
          )),
    );
  }

  tabItems(String text, String image, int index, BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset(
        image,
      ),
      Text(
        text,
        style: TextStyle(
          fontFamily: "oswald",
          fontSize: size.height / 45,
          color: currentIndex == index ? Colors.black : Colors.grey,
        ),
      )
    ]);
  }
}
