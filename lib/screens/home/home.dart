import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:todaynews/screens/blog/add_blog_page.dart';
import 'package:todaynews/screens/home/dashboard.dart';
import 'package:todaynews/screens/user_profile_page.dart';
import 'package:todaynews/services/auth_services.dart';
import 'package:todaynews/utils/validator.dart';
import 'package:todaynews/widgets/custom_text_button.dart';
import 'package:todaynews/widgets/input_form_field.dart';
import 'dart:io';

import '../blog/blog_page.dart';

class Home extends StatefulWidget {
   final AuthClass? auth;
  final VoidCallback? onSignedOut;
  const Home({Key? key, this.auth, this.onSignedOut}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final formKey = GlobalKey<FormState>();
  //000e697ec62d4f4184f318f61b8693a0
  final titleController = TextEditingController();
  final desController = TextEditingController();
  FirebaseStorage storage = FirebaseStorage.instance;

  File? imageUrl;
  int currentIndex = 0;

  final ImagePicker _imagePicker = ImagePicker();

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: PageStorage(bucket: bucket, child: currentScreen),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) =>  AddBlogPage(imageUrl: null,)));
    
        }
      ),
      bottomNavigationBar: BottomAppBar(
          elevation: 5,
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
                  child: tabItems("News", Icons.notes, 0, context),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = const BlogPage();
                      currentIndex = 1;
                    });
                  },
                  child: tabItems("Blog", Icons.pages, 1, context),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = UserProfilePage();
                      currentIndex = 2;
                    });
                  },
                  child: tabItems("User profiel", Icons.person, 2, context),
                )
              ],
            ),
          )),
    );
  }

  Column tabItems(String text, IconData icon, int index, BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(
        icon,
        size: size.height / 25.76,
        color: currentIndex == index ? Colors.black : Colors.grey,
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
