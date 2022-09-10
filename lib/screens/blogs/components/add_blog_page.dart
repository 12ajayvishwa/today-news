import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:todaynews/model/blog_data_model.dart';
import 'package:uuid/uuid.dart';
import '../../../utils/validator.dart';
import '../../../widgets/custom_text_button.dart';
import '../../../widgets/input_form_field.dart';
import '../body/blog_page.dart';

class AddBlogPage extends StatefulWidget {
  const AddBlogPage({Key? key}) : super(key: key);

  @override
  State<AddBlogPage> createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  final formKey = GlobalKey<FormState>();
  final authorNameController = TextEditingController();
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  BlogModel blogModel = BlogModel();

  File? imageUrl;
  // ignore: prefer_typing_uninitialized_variables
  var downloadedUrl;
  bool isLoading = false;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  Future<void> imgFromGallery() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imageUrl = File(pickedFile.path);
      }
    });
  }

  void uploadImage(BuildContext context, url) async {
    if (imageUrl == null) return;
    setState(() {
      isLoading = true;
    });
    final filename = basename(imageUrl!.path);
    final destination = 'files/$filename';

    try {
      final ref = FirebaseStorage.instance.ref(destination).child('file/');
      var timeKey = DateTime.now();

      final UploadTask task =
          ref.child("$timeKey.jpg").putFile(imageUrl!);

      var downloadUrl = await (await task).ref.getDownloadURL();
      downloadedUrl = downloadUrl.toString();
      // ignore: use_build_context_synchronously
      await saveToDatabase(downloadedUrl, context);
      // ignore: avoid_print
      print("this is url $downloadUrl");
      setState(() {});
    } catch (e) {
      Fluttertoast.showToast(msg: "Something wrong");
    }
  }

  Future<void> saveToDatabase(url, BuildContext context) async {
    String id = const Uuid().v1();
    var timeKey = DateTime.now();
    var formateDate = DateFormat('MMM d, yyyy');
    var formateTime = DateFormat('EEEE, hh:mm aaa');

    String date = formateDate.format(timeKey);
    String time = formateTime.format(timeKey);

    // DatabaseReference ref = FirebaseDatabase.instance.ref();
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    goToBlogPage(context);
    Map<String, dynamic> blogDetails = {
      'id': id,
      'authorName': authorNameController.text,
      'title': titleController.text,
      'desc': descController.text,
      'url': url,
      'date': date,
      'time': time
    };

    await firebaseFirestore
        .collection('blogs')
        .doc(id)
        .set(blogDetails)
        .then((value) {
      saveDataToMyBlogs(id);
    });
  }

  Future<void> saveDataToMyBlogs(String id) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('myBlogs')
          .doc(id)
          .set({
        'id': id,
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
    }
  }

  Future<List> getMyBlogs() async {
    try {
      var snapshot = await _firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection("myBlogs")
          .get();
      return snapshot.docs.map((e) => e.data()['id']).toList();
    } catch (e) {
      Fluttertoast.showToast(msg: "$e");
      return [];
    }
  }

  void goToBlogPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => BlogPage()));
  }

  void validateAndSubmit(BuildContext context) {
    if (formKey.currentState!.validate()) {
      uploadImage(
        context,
        downloadedUrl,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoading
        ? Scaffold(
            body: Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color.fromARGB(31, 247, 241, 241),
              title: const Text(
                "Write Your Blog",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontFamily: "oswald",
                    fontWeight: FontWeight.w500),
              ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                  )),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, right: 10.0, top: 15),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          imageUrl != null ? imageContainer() : textContainer(),
                          const SizedBox(
                            height: 40,
                          ),
                          authorNameField(size),
                          const SizedBox(
                            height: 15,
                          ),
                          titleNameField(size),
                          const SizedBox(
                            height: 15,
                          ),
                          descField(size),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          submitForm(size, context)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ));
  }

  submitForm(Size size, BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: size.width,
        child: Container(
            height: 50,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18), color: Colors.green),
            child: CustomTextButton(
              color: Colors.white,
              onPressed: () => validateAndSubmit(context),
              text: 'Submit Blog',
            )));
  }

  descField(Size size) {
    return DescriptionField(
      controller: descController,
      hintText: 'Description.....',
      textInputAction: TextInputAction.done,
      size: size,
      textInputType: TextInputType.multiline,
      labelText: 'Description',
    );
  }

  titleNameField(Size size) {
    return TextFormFields(
        size: size,
        controller: titleController,
        validator: titleValidator,
        hintText: 'Enter Title',
        labelText: "Title",
        textInputAction: TextInputAction.done,
        textInputType: TextInputType.text);
  }

  authorNameField(Size size) {
    return TextFormFields(
        size: size,
        controller: authorNameController,
        validator: nameValidator,
        hintText: "Author name",
        labelText: "Author name",
        textInputAction: TextInputAction.next,
        textInputType: TextInputType.name);
  }

  textContainer() {
    return Container(
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey)),
        child: Center(
            child: TextButton(
          onPressed: () {
            imgFromGallery();
          },
          child: const Text(
            "Select image",
            style: TextStyle(fontFamily: "oswald"),
          ),
        )));
  }

  imageContainer() {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: FileImage(
                imageUrl!,
              ),
              fit: BoxFit.cover)),
    );
  }
}
