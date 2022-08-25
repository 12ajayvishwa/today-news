import 'package:flutter/material.dart';
import 'package:todaynews/utils/validator.dart';
import 'package:todaynews/widgets/input_form_field.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text_button.dart';
import '../widgets/logo_text.dart';
import 'phone_verification_page.dart';

class SignUpPage extends StatefulWidget {
  final String? phoneNumber;
  const SignUpPage({Key? key, this.phoneNumber}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isVisible = true;

  // void _sendPhoneNumber(BuildContext context){
  //   String phoneNumber = phoneNumberController.text;
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneVerificationPage(phoneNumber: phoneNumber,)));
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              top: size.height * 0.1,
              left: size.width * 0.04,
              right: size.width * 0.04),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LogoText(
                  firstText: "Today",
                  secondText: "News",
                ),
                const SizedBox(
                  height: 15,
                ),
                _signupFormWidget(size, context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _signupFormWidget(Size size, BuildContext context) {
    return Form(
        key: _formKey,
        child: SizedBox(
            height: size.height / 1.5,
            width: size.width * 0.9,
            child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: _signupFieldWidget(size),
                ))));
  }

  _signupFieldWidget(Size size) {
    return SizedBox(
      height: size.height * 0.32,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          TextFormFields(
              size: size,
              controller: nameController,
              validator: nameValidator,
              hintText: "Enter your name",
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.name),
          const SizedBox(
            height: 10,
          ),
          TextFormFields(
              size: size,
              controller: emailController,
              validator: emailValidator,
              hintText: "Enter your email id",
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.emailAddress),
          const SizedBox(
            height: 10,
          ),
          TextFormFields(
              size: size,
              controller: addressController,
              validator: addressValidator,
              hintText: "Enter your address",
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.streetAddress),
          SizedBox(
            height: 10,
          ),
          PhoneNumberInputField(
            controller: phoneNumberController,
            hintText: 'Enter phone number',
            size: size,
            textInputType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 10,),
          TextFormFields(
              size: size,
              controller: passwordController,
              validator: passwordValidator,
              hintText: "Enter password",
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.text,
              obsecureText: isVisible,
              iconButton: IconButton(
                icon:Icon(isVisible?Icons.visibility_off:Icons.visibility),color: isVisible?const Color(0xFFC3C2C2):Colors.blue,onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },)),
                SizedBox(height: 15,),
                CustomButton(
            size: size,
            text: 'SignUp',
            radius: BorderRadius.circular(18),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                print(nameController.text);
                print(emailController.text);
                print(addressController.text);
                print(phoneNumberController.text);
                print(passwordController.text);
                Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneVerificationPage()));
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Proccessing Data")));
              }
            },
          ),
          CustomTextButton(
                text: "Already have an account? Login",
                onPressed: () {
                  print("nope");
                },
                color: Colors.black,
              ),
        ],
      ),
    );
  }
}
