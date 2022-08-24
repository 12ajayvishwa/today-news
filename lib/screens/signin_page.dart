

import 'package:flutter/material.dart';
import 'package:todaynews/utils/dimensions.dart';
import 'package:todaynews/utils/validator.dart';

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: size.height*0.2,left: size.width*0.04,right: size.width*0.04),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LogoText(firstText: "Today",secondText: "News",),
              TextFormFields(hintText: "Username",controller: usernameController,size: size,validator: nameValidator,textInputType: TextInputType.name,)
            ],
          ),
        ),
      ),
    );
  }
}
