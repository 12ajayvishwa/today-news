
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:todaynews/services/blog_data_service.dart';

import '../../utils/validator.dart';
import '../../widgets/custom_text_button.dart';
import '../../widgets/input_form_field.dart';


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

  BlogDataService blogDataService = BlogDataService();


  File? imageUrl;
  var urlDownload;
  bool isLoading = false;

  final ImagePicker _imagePicker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imageUrl = File(pickedFile.path);
      }
    });
  }

  uploadBlog() async {
    if (imageUrl == null) return;
    setState(() {
      isLoading = true;
    });
    final filename = basename(imageUrl!.path);
    final destination = 'files/$filename';

    try {
      final ref = FirebaseStorage.instance.ref(destination).child('file/');

      final UploadTask task = ref.putFile(imageUrl!);

    
      var downloadUrl = await (await task).ref.getDownloadURL();
      setState(() {
        urlDownload = downloadUrl;
      });
      print("this is url $downloadUrl");



    

    } catch (e) {
      Fluttertoast.showToast(msg: "Something wrong");
    }
  }


  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
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
          icon: Icon(Icons.arrow_back,color: Colors.grey,)),
        centerTitle: true,
      ),
      body: isLoading ? Container(
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ):
      
      
      SingleChildScrollView(
        child: Container(child: Column(
          children: [
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 15),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    imageUrl != null
                        ? Container(
                          height: 80,
                            width: double.infinity,
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(image: FileImage(imageUrl!,),fit: BoxFit.cover)
                        
                          ),
                          )
                        : Container(
                            height: 80,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(18),
                                border:
                                    Border.all(color: Colors.grey)),
                            child: Center(
                                child: TextButton(
                                  onPressed: () {
                                    imgFromGallery();
                                  },
                                  child: const Text(
                                                                          "Select image selected",
                                                                          style:
                                    TextStyle(fontFamily: "oswald"),
                                                                        ),
                                ))),
                    const SizedBox(
                      height: 40,
                    ),
                    TextFormFields(
                      size: size, 
                      controller: authorNameController, 
                      validator: nameValidator, 
                      hintText: "Author name", 
                      labelText: "Author name",
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.name),
                      const SizedBox(height: 15,),
                    TextFormFields(
                        size: size,
                        controller: titleController,
                        validator: titleValidator,
                        hintText: 'Enter Title',
                        labelText: "Title",
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.text),
                    const SizedBox(
                      height: 15,
                    ),
                    DescriptionField(
                      controller: descController,
                      hintText: 'Description.....',
                      textInputAction: TextInputAction.done,
                      size: size,
                      textInputType: TextInputType.multiline,
                      labelText: 'Description',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                   
                        
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                        alignment: Alignment.center,
                        width: size.width,
                        child: Container(
                            height: 50,
                            width: 120,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(18),
                                color: Colors.green),
                            child: CustomTextButton(
                              color: Colors.white,
                              onPressed: () {
                                if (formKey.currentState!
                                    .validate()) {
                                  uploadBlog();
                                 blogDataService.postBlogToFirestore(
                                  authorNameController.text, 
                                  descController.text, 
                                  titleController.text, 
                                  
                                 urlDownload!, 
                                  context);
                                }
                              },
                              text: 'Submit Blog',
                            )))
                  ],
                ),
              ),
            )
                      ],
                    ),
        ),
      )
      
    );
  }
}