import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:todaynews/utils/input_field_decoration.dart';

class TextFormFields extends StatelessWidget {
  final Size size;
  final TextEditingController controller;
  final FormFieldValidator validator;
  final String hintText;
  final TextInputType textInputType;
  final IconButton? iconButton;
  final bool? obsecureText;
  final TextInputAction? textInputAction;
  const TextFormFields(
      {Key? key,
      required this.size,
      required this.controller,
      required this.validator,
      required this.hintText,
      required this.textInputType,
      this.iconButton,
      this.obsecureText,
      this.textInputAction})
      : super(key: key);

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
          textInputAction: textInputAction,
          validator: validator,
          decoration: inputDecoration(
            hintText,
            iconButton: iconButton,
          ),
          obscureText: obsecureText ?? false,
        ),
      ],
    );
  }
}

class PhoneNumberInputField extends StatelessWidget {
  final Size size;
  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
  final TextInputAction? textInputAction;
  const PhoneNumberInputField(
      {Key? key,
      required this.size,
      required this.controller,
      required this.hintText,
      required this.textInputType,
      this.textInputAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: size.height * 0.08,
          width: size.width * 0.9,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
          child: IntlPhoneField(
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.bottom,
            autofocus: false,
            controller: controller,
            keyboardType: textInputType,
            onSaved: (value) {
              controller.text = value! as String;
            },
            textInputAction: textInputAction,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: inputDecoration(
              hintText,
            ),
            initialCountryCode: "IN",
            onChanged: (phone) {
              print(phone.completeNumber);
            },
            onCountryChanged: (country){
              print('Country changed to: ' + country.name);
            },
          ),
        ),
      ],
    );
  }
}
