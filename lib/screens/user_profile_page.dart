import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
  UserModel loggedInUser = UserModel();

  String? _userName;
  File? imageUrl;
  var _downloadedUrl;
  var profilePic = "";
  bool isLoading = false;
  bool isUploaded = false;

  Future imgFromGallery() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
       imageUrl = File(pickedFile.path);
      }
    });
  }

  Future uploadFile() async {
    if (imageUrl == null) return;
    final filename = basename(imageUrl!.path);
    final destination = 'users/$filename';

    try {
      final ref = FirebaseStorage.instance.ref().child('users');
      await ref.putFile(imageUrl!);

      final UploadTask task =
          ref.putFile(imageUrl!);

     var downloadUrl = await (await task).ref.getDownloadURL();
     _downloadedUrl = downloadUrl.toString();
     await saveToDatabase(_downloadedUrl);
     setState(() {
       profilePic = _downloadedUrl;
     });
     print("this is url $downloadUrl");
    } catch (e) {
      print("error occured");
    }
  }

  Future saveToDatabase(url) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    var data = {
      "image": _downloadedUrl,
    };
    ref.child("users").push();
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
        body: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      child: 
                    imageUrl != null ?
                Container(
                  height: size.height * 0.15,
                  width: size.width * 0.25,
                  decoration: BoxDecoration(
                   
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue, width: 2),
                      image: DecorationImage(
                          image: NetworkImage(profilePic),fit: BoxFit.contain)),
                ):
                Container(
                  height: size.height * 0.15,
                  width: size.width * 0.25,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue, width: 2),
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://icons.veryicon.com/png/o/internet--web/prejudice/user-128.png"),
                          fit: BoxFit.contain)),
                ),),
                Positioned(
                  top: 8,
                  right: 5,
                  child: InkWell(
                    onTap: () {
                      print("hiii");
                    },
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white),
                      child: Icon(
                        Icons.edit,color: Colors.grey,)),
                  )),
                  
                  ],
                ),
                Text(loggedInUser.name ?? "",
                softWrap: true,
                style: TextStyle(color: Colors.black,fontFamily: "oswald",fontSize: 25,fontWeight: FontWeight.w500),),
                  Text(loggedInUser.email ?? "",
                  softWrap: true,
                  style: TextStyle(color: Colors.grey,fontFamily: "oswald",fontSize: 18,fontWeight: FontWeight.w200),)
                ,
                Row(
                  children: [
                    imageUrl != null ?
                    ElevatedButton(
                      onPressed: (){
                        uploadFile();
                      }, child: Text(
                        "Upload Your Photo")):
                    ElevatedButton(
                      onPressed: (){
                    imgFromGallery();
                  }, child:
                  Text("Change Your Photo")),


                  
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  alignment: Alignment.bottomLeft,
                  width: size.width,
                  child: Text("Address :- ${loggedInUser.address ?? ""}",style: TextStyle(color: Colors.black,fontFamily: "Lato",fontSize: 20,fontWeight: FontWeight.normal),)),
                Container(
                  padding: EdgeInsets.all(12),
                  alignment: Alignment.bottomLeft,
                  width: size.width,
                  child: Text("Email ID :- ${loggedInUser.email ?? ""}",style: TextStyle(color: Colors.black,fontFamily: "Lato",fontSize: 20,fontWeight: FontWeight.normal),)),
                  Container(
                  padding: EdgeInsets.all(12),
                  alignment: Alignment.bottomLeft,
                  width: size.width,
                  child: Text("Phone Number :- ${loggedInUser.phoneNumber ?? ""}",style: TextStyle(color: Colors.black,fontFamily: "Lato",fontSize: 20,fontWeight: FontWeight.normal),)),
                  Container(
                  
                  padding: EdgeInsets.all(12),
                  alignment: Alignment.bottomLeft,
                  width: size.width,
                  child: Text(
                    "User Id :- ${loggedInUser.uid ?? ""}",style: TextStyle(color: Colors.black,fontFamily: "Lato",fontSize: 18,fontWeight: FontWeight.normal),))
                
                // StreamBuilder(
                //   stream: FirebaseFirestore.instance
                //   .collection("users")
                //   .where("uid",isEqualTo: auth.currentUser!.uid)
                //   .snapshots(),
                //   builder: ((context, snapshot){
                //     if(snapshot.hasData){

                //     }
                //   }))
              ],
            )));
  }

  
  }

