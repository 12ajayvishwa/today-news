import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:todaynews/model/user_data.dart';
import 'package:todaynews/services/auth_services.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final formKey = GlobalKey<FormState>();

  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  
  UserModel loggedInUser = UserModel();

  String? _userName;
  File? image;
 
  var profilePic = "";
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
    String postId=DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref('users').child("image").child("post_$postId.jpg");
    await reference.putFile(image);
    downloadUrl = await reference.getDownloadURL();
    return downloadUrl;
    
    // if (imageUrl == null) return;
    // final filename = basename(imageUrl!.path);
    // final destination = 'users$filename';
    // final uid = auth.currentUser!.uid;

    // try {
    //   final ref = FirebaseStorage.instance.ref(destination).child('profilePic.jpg');
    //   await ref.putFile(imageUrl!);

    //   final UploadTask task = ref.putFile(imageUrl!);

    //   var downloadUrl = await (await task).ref.getDownloadURL();
    //   _downloadedUrl = downloadUrl.toString();
    //   await saveToDatabase(_downloadedUrl);
    //   setState(() {
    //     profilePic = _downloadedUrl;
    //   });
    //   print("this is url $downloadUrl");
    // } catch (e) {
    //   print("error occured");
    // }
  }

  Future uploadToDatabase() async {
    String url = await uploadFile(image!);
    final users = _firebaseFirestore.collection('users');
    final uid = auth.currentUser;
    await users.doc(uid!.uid).update({'url': url});
    // DatabaseReference ref = FirebaseDatabase.instance.ref();
    // var data = {
    //   "image": _downloadedUrl,
    // };
    // ref.child("users").push();
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
    return 
    Scaffold(
        body: isLoading ? Center(child: CircularProgressIndicator()):
        
        Container(
            padding: EdgeInsets.only(left: 18, right: 18),
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                image != null
                    ? Container(
                        height: size.height * 0.15,
                        width: size.width * 0.25,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 2),
                            image: DecorationImage(
                              image: FileImage(
                               image!
                              ),
                              fit: BoxFit.cover,
                            )),
                      )
                    : Container(
                        height: size.height * 0.15,
                        width: size.width * 0.25,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue, width: 2),
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://icons.veryicon.com/png/o/internet--web/prejudice/user-128.png"),
                                fit: BoxFit.cover)),
                      ),
                Text(
                  loggedInUser.name ?? "",
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "oswald",
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  loggedInUser.email ?? "",
                  softWrap: true,
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: "oswald",
                      fontSize: 18,
                      fontWeight: FontWeight.w200),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          uploadToDatabase();
                        },
                        child: Text("Upload Your Photo")),
                    ElevatedButton(
                        onPressed: () {
                          imgFromGallery();
                        },
                        child: Text("Change Your Photo")),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                userDeatils(size, "assets/user.png", loggedInUser.name, () {
                  
                }),
                SizedBox(
                  height: 8,
                ),
                userDeatils(size, "assets/location.png", loggedInUser.address,
                    () {
                  print("hii");
                }),
                SizedBox(
                  height: 8,
                ),
                userDeatils(
                    size, "assets/email_address.png", loggedInUser.email, () {
                  print("hiii");
                }),
                SizedBox(
                  height: 8,
                ),
                userDeatils(
                    size, "assets/telephone.png", loggedInUser.phoneNumber, () {
                  print("hiiii");
                })
              ],
            )));
  }

  userDeatils(Size size, String image, loggedInUser, VoidCallback onTap) {
    return Container(
        height: size.height / 9.5,
        width: size.width,
        padding: EdgeInsets.all(15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
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
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    loggedInUser ?? "",
                    style: TextStyle(
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
