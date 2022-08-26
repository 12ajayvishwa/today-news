import 'package:flutter/material.dart';

class LogoText extends StatelessWidget {
  final String firstText;
  final String secondText;

  // ignore: prefer_const_constructors_in_immutables
  LogoText({Key? key, required this.firstText, required this.secondText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: firstText.toUpperCase(),
          style: const TextStyle(
              fontSize: 30,
              fontFamily: "oswald",
              fontWeight: FontWeight.w500,
              color: Colors.yellow),
          children: <TextSpan>[
            TextSpan(
              text: secondText.toUpperCase(),
              style: const TextStyle(
                  fontSize: 25,
                  fontFamily: "oswald",
                  fontWeight: FontWeight.w500,
                  color: Colors.black12),
            )
          ]),
    );
  }
}
