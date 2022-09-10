import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget {
  Widget? title;
  VoidCallback? profileTab;
  VoidCallback? logoutTab;
  Widget? icon;
  Color? color;
  CustomAppBar({
    Key? key,
    this.title,
    this.profileTab,
    this.logoutTab,
    this.icon,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return AppBar(
      leading: InkWell(
        onTap: profileTab,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: size.height * 0.035,
            width: size.width * 0.035,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
              // image: const DecorationImage(image: NetworkImage("https://avatars.githubusercontent.com/u/74170974?s=400&v=4"))),
            ),
            child: const Center(
                child: Icon(
              Icons.person,
              color: Colors.grey,
            )),
          ),
        ),
      ),
      title: title,
      actions: [IconButton(onPressed: logoutTab,icon: icon!,)],
      centerTitle: true,
      backgroundColor: color,
      elevation: 0,
    );
  }
}
