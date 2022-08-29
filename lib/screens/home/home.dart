import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todaynews/screens/add_blog_page.dart';
import 'package:todaynews/screens/home/dashboard.dart';
import 'package:todaynews/screens/user_profile_page.dart';
import 'package:todaynews/utils/validator.dart';
import 'package:todaynews/widgets/custom_text_button.dart';
import 'package:todaynews/widgets/input_form_field.dart';
import 'dart:io';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final formKey = GlobalKey<FormState>();
  //000e697ec62d4f4184f318f61b8693a0
  final titleController = TextEditingController();
  final desController = TextEditingController();

  int currentIndex = 0;
  UploadTask? task;
  File? file;

  final List<Widget> pages = [
    const Dashboard(),
    const AddBlogPage(),
    const UserProfilePage()
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const Dashboard();

  // Future getImage() async {
  //   var tempImage = await FilePicker.platform.pickFiles(allowMultiple: false);
  //   if(tempImage == null) return;
  //   final path = tempImage.files.single.path!;
  //   setState(() {
  //     file = File(path);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
final fileName = file != null ? File(file!.path): "No file selected";
    return Scaffold(
      body: PageStorage(bucket: bucket, child: currentScreen),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              elevation: 5,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Wrap(
                    children: [
                      Container(
                        height: size.height / 1.7,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 15),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Write Your Blog",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: "oswald",
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                TextFormFields(
                                    size: size,
                                    controller: titleController,
                                    validator: titleValidator,
                                    hintText: 'Enter Title',
                                    labelText: "Title",
                                    textInputAction: TextInputAction.done,
                                    textInputType: TextInputType.text),
                                const SizedBox(
                                  height: 10,
                                ),
                                DescriptionField(
                                  controller: desController,
                                  hintText: 'Description.....',
                                  textInputAction: TextInputAction.newline,
                                  size: size,
                                  textInputType: TextInputType.multiline,
                                  labelText: 'Description',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                
                                Container(
                                  width: size.width / 2.5,
                                  child: ElevatedButton(
                                      onPressed: (){},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: const [
                                          Icon(Icons.attach_file),
                                          Text("Upload image")
                                        ],
                                      )),
                                ),
                                
                                Text(fileName as String),
                                const SizedBox(
                                  height: 60,
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
                                              Fluttertoast.showToast(
                                                  msg: "submitted");
                                            }
                                          },
                                          text: 'Submit Blog',
                                        )))
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              });
        },
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
                  child: tabItems("News", Icons.notes, 0),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = const AddBlogPage();
                      currentIndex = 1;
                    });
                  },
                  child: tabItems("Blog", Icons.pages, 1),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    setState(() {
                      currentScreen = const UserProfilePage();
                      currentIndex = 2;
                    });
                  },
                  child: tabItems("User profiel", Icons.person, 2),
                )
              ],
            ),
          )),
    );
  }

  Column tabItems(String text, IconData icon, int index) {
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
