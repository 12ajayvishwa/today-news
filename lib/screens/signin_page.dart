import 'package:flutter/material.dart';
import 'package:todaynews/utils/validator.dart';
import 'package:todaynews/widgets/custom_text_button.dart';

import '../widgets/custom_button.dart';
import '../widgets/logo_text.dart';
import '../widgets/input_form_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              top: size.height * 0.2,
              left: size.width * 0.04,
              right: size.width * 0.04),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LogoText(
                  firstText: "Today",
                  secondText: "News",
                ),
                const SizedBox(
                  height:  15,
                ),
                _loginFormWidget(size, context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _loginFormWidget(Size size, BuildContext context) {
    return Form(
        key: _formKey,
        child: SizedBox(
          height: size.height/2.6,
          width: size.width * 0.9,
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child:_loginFieldsWidget(size),
              )
            
            
          ),
        ));
  }

  _loginFieldsWidget(Size size) {
    return SizedBox(
      height: size.height * 0.32,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          TextFormFields(
            hintText: "Enter Username",
            controller: usernameController,
            size: size,
            validator: emailValidator,
            textInputType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextFormFields(
            size: size,
            controller: passwordController,
            validator: passwordValidator,
            hintText: "Enter Password",
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.text,
            iconButton: IconButton(
              icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
              color: isVisible ? const Color(0xFFC3C2C2) : Colors.blue,
              onPressed: (() {
                setState(() {
                  isVisible = !isVisible;
                });
              }),
            ),
            obsecureText: isVisible,
          ),
          const SizedBox(
            height: 15.0,
          ),
          CustomButton(
            size: size,
            text: 'Login',
            radius: BorderRadius.circular(18),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Proccessing Data")));
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextButton(
                text: "Register",
                onPressed: () {},
                color: Colors.black,
              ),
              CustomTextButton(
                text: "Forgot password?",
                onPressed: () {},
                color: Colors.black,
              )
            ],
          )
        ],
      ),
    );
  }
}
