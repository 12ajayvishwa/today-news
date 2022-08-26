import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  const CustomTextButton({Key? key, required this.text, required this.onPressed, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed, 
      child: Text(
        text,
        style: TextStyle(
            fontFamily: "oswald",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: color),
      ));
  }
}