import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todaynews/utils/input_field_decoration.dart';

class TextFormFields extends StatelessWidget {
  final Size size;
  final TextEditingController controller;
  final FormFieldValidator validator;
  final String hintText;
  final TextInputType textInputType;
  const TextFormFields({Key? key, required this.size, required this.controller, required this.validator, required this.hintText, required this.textInputType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            height: size.height * 0.05,
            width: size.width * 0.8,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(8.0))),
        TextFormField(
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.bottom,
          autofocus: false,
          controller: controller,
          keyboardType: textInputType,
          onSaved: (value) {
            controller.text = value!;
          },
          textInputAction: TextInputAction.next,
          validator: validator,
          decoration: inputDecoration(hintText),
        ),
      ],
    );
  }
}