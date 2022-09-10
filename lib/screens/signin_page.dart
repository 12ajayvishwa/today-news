import 'package:flutter/material.dart';
import 'package:todaynews/screens/forget_password_page.dart';
import 'package:todaynews/screens/signup_page.dart';
import 'package:todaynews/services/firebase/auth_services.dart';
import 'package:todaynews/utils/validator.dart';
import 'package:todaynews/widgets/custom_text_button.dart';

import '../widgets/custom_button.dart';
import '../widgets/logo_text.dart';
import '../widgets/input_form_field.dart';

class SignInPage extends StatefulWidget {
  final AuthClass? auth;
  final VoidCallback? onSignedIn;
  const SignInPage({Key? key, this.auth, this.onSignedIn,}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isVisible = true;
  bool showLoading = false;

  final AuthClass _authClass = AuthClass();

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
          child: showLoading
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    Text(
                      "Data in progress....",
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: "oswald",
                      ),
                    )
                  ],
                ))
              : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LogoText(
                        firstText: "Today",
                        secondText: "News",
                      ),
                      const SizedBox(
                        height: 55,
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
          height: size.height / 2.6,
          width: size.width * 0.9,
          child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: _loginFieldsWidget(size),
              )),
        ));
  }

  _loginFieldsWidget(Size size) {
    return SizedBox(
      height: size.height * 0.32,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          TextFormFields(
            hintText: "Enter username/email",
            controller: emailController,
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
            radius: BorderRadius.circular(15),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                
                await _authClass.signIn(
                    emailController.text, passwordController.text, context);

              
                setState(() {
                  showLoading = true;
                });
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextButton(
                text: "Register",
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SignUpPage()));
                },
                color: Colors.black,
              ),
              CustomTextButton(
                text: "Forgot password?",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ForgetPasswordPage()));
                },
                color: Colors.black,
              )
            ],
          )
        ],
      ),
    );
  }
}
