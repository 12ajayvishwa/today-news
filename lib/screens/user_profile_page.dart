import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todaynews/model/user_data.dart';

import 'signin_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final formKey = GlobalKey<FormState>();
final _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  UserModel loggedInUser = UserModel();
  File? image;
  String? userImage;

  bool isLoading = true;
  bool isUploaded = false;

  Future imgFromGallery() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      }
    });
  }

  Future uploadFile(File image) async {
    String downloadUrl;
    String postId = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance
        .ref('users')
        .child("image")
        .child("post_$postId.jpg");
    await reference.putFile(image);
    downloadUrl = await reference.getDownloadURL();
    setState(() {
      userImage = downloadUrl;
    });
    return downloadUrl;
  }

  Future uploadToDatabase() async {
    String url = await uploadFile(image!);
    final users = _firebaseFirestore.collection('users');
    final uid = auth.currentUser;
    await users.doc(uid!.uid).update({'url': url});

  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {
        isLoading = !isLoading;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                padding: const EdgeInsets.only(left: 18, right: 18),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Container(
                      height: size.height * 0.15,
                      width: size.width * 0.25,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFF38B6FF), width: 2),
                          image: DecorationImage(
                            image: userImage == ""
                                ? const NetworkImage(
                                    "https://png.pngtree.com/element_our/png/20181206/users-vector-icon-png_260862.jpg")
                                : NetworkImage(loggedInUser.url ?? ""),
                            fit: BoxFit.cover,
                          )),
                    ),
                    Text(
                      loggedInUser.name ?? "",
                      softWrap: true,
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: "oswald",
                          fontSize: 25,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      loggedInUser.email ?? "",
                      softWrap: true,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontFamily: "oswald",
                          fontSize: 18,
                          fontWeight: FontWeight.w200),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Color(0xFF38B6FF)),
                            onPressed: () {
                              uploadToDatabase();
                            },
                            child: const Text("Upload Your Photo")),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Color(0xFF38B6FF)),
                            onPressed: () {
                              imgFromGallery();
                            },
                            child: const Text("Change Your Photo")),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    userDeatils(
                        size, "assets/user.png", loggedInUser.name, () {}),
                    const SizedBox(
                      height: 8,
                    ),
                    userDeatils(
                        size, "assets/location.png", loggedInUser.address, () {
                      print("hii");
                    }),
                    const SizedBox(
                      height: 8,
                    ),
                    userDeatils(
                        size, "assets/email_address.png", loggedInUser.email,
                        () {
                      print("hiii");
                    }),
                    const SizedBox(
                      height: 8,
                    ),
                    userDeatils(
                        size, "assets/telephone.png", loggedInUser.phoneNumber,
                        () {
                      // ignore: avoid_print
                      print("hiiii");
                    }),
                    const SizedBox(height: 25,),
                    InkWell(
                      onTap: () async {
              await _auth.signOut();
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const SignInPage()));
              
            },
                      child: Column(
                        children: [
                          Image.asset("assets/power-off.png"),
                          const Text(
                            "Logout",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 25,
                                fontFamily: "Lato"),
                          )
                        ],
                      ),
                    )
                  ],
                )));
  }

  userDeatils(Size size, String image, loggedInUser, VoidCallback onTap) {
    return Container(
        height: size.height * 0.08,
        width: size.width,
        padding: const EdgeInsets.all(15),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  Image.asset(
                    image,
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    loggedInUser ?? "",
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: "Lato",
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
