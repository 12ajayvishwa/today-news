import 'package:flutter/material.dart';

InputDecoration inputDecoration(String hintText,{IconButton? iconButton, Widget? prefixIcon, String? labelText,}){
  return InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 12.0),
      hintText: hintText,
      labelText: labelText,
      labelStyle: const TextStyle(
          fontFamily: "oswald",
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: Colors.blue),
      hintStyle: const TextStyle(
          fontFamily: "oswald",
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Color(0xFFA8A7A7)),
          prefixIcon: prefixIcon,
          suffixIcon: iconButton,
      filled: true,
      fillColor: const Color(0xFFF5F7FB),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none));
}
