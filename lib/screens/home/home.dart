import 'package:flutter/material.dart';
import 'package:todaynews/screens/add_blog_page.dart';
import 'package:todaynews/screens/home/dashboard.dart';
import 'package:todaynews/screens/user_profile_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //000e697ec62d4f4184f318f61b8693a0
  int currentIndex = 0;

  final List<Widget> pages = [
    const Dashboard(),
    const AddBlogPage(),
    const UserProfilePage()
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const Dashboard();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: bucket, child: currentScreen),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            currentScreen = const AddBlogPage();
            currentIndex = 1;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
