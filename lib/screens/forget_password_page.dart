import 'package:flutter/material.dart';
import 'package:todaynews/services/auth_services.dart';
import 'package:todaynews/utils/validator.dart';
import 'package:todaynews/widgets/custom_button.dart';
import 'package:todaynews/widgets/input_form_field.dart';
import 'package:todaynews/widgets/logo_text.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  final AuthClass _authClass = AuthClass();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
            top: size.height * 0.1,
            left: size.width * 0.04,
            right: size.width * 0.04),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                LogoText(firstText: "NEWS", secondText: "TODAY"),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Recover your password\nusing email",
                  style: TextStyle(
                      fontFamily: "oswald",
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormFields(
                    size: size,
                    controller: emailController,
                    validator: emailValidator,
                    hintText: "Enter your email id",
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.emailAddress),
                const SizedBox(
                  height: 15,
                ),
                CustomButton(
                    text: "Continue",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _authClass.forgotPassword(
                            emailController.text.trim(), context);
                      }
                    },
                    radius: BorderRadius.circular(15),
                    size: size)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
