import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget {
  Widget? title;
  VoidCallback? profileTab;
  VoidCallback? logoutTab;
  VoidCallback? searchTab;
  Widget? userProfile;
  Widget? favouriteIcon;
  IconData? searchIcon;
  Color? color;
  CustomAppBar({
    Key? key,
    this.title,
    this.profileTab,
    this.logoutTab,
    this.searchTab,
    this.userProfile,
    this.favouriteIcon,
    this.searchIcon,
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
              child: userProfile),
        ),
      ),
      title: title,
      actions: [
        IconButton(
            onPressed: searchTab,
            icon: Icon(
              searchIcon,
              color: Color(0xFF38B6FF),
              size: 30,
            )),
        IconButton(
          onPressed: logoutTab,
          icon: favouriteIcon!,
        ),
        
      ],
      centerTitle: true,
      backgroundColor: color,
      elevation: 0,
    );
  }
}
