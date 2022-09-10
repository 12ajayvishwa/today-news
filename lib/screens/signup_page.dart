import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:todaynews/screens/signin_page.dart';
import 'package:todaynews/services/firebase/auth_services.dart';
import 'package:todaynews/utils/validator.dart';
import 'package:todaynews/widgets/input_form_field.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text_button.dart';
import '../widgets/logo_text.dart';
import 'home/home.dart';

enum MobileVerificationState {
  // ignore: constant_identifier_names
  SHOW_REGISTER_STATE,
  // ignore: constant_identifier_names
  SHOW_OTP_FORM_STATE,
}

class SignUpPage extends StatefulWidget {
  final String? phoneNumber;
  const SignUpPage({Key? key, this.phoneNumber}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_REGISTER_STATE;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController(text: "");

  bool isVisible = true;
  bool isResendAgain = false;
  bool isVerified = false;

  String code = '';


  // void _sendPhoneNumber(BuildContext context){
  //   String phoneNumber = phoneNumberController.text;
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneVerificationPage(phoneNumber: phoneNumber,)));
  // }

  final AuthClass _authClass = AuthClass();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String verificationId;

  bool showLoading = false;
  String smsCode = "";

  @override
  void initState() {
    super.initState();
    _listenOtp();
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });

      if (authCredential.user != null) {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Home()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      Fluttertoast.showToast(msg: e.message as String);
    }
  }
 final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              top: size.height * 0.1,
              left: size.width * 0.04,
              right: size.width * 0.04),
          child: showLoading?

           Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                        Text(
                          "Verification in progress....",
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: "oswald",
                          ),
                        )
                      ],
                    ),
                  ): currentState == MobileVerificationState.SHOW_REGISTER_STATE
                    ? signupFormWidget(size:size,context:context)
                    
                    :getOtpFormWidget(context)
                    
                    
                  
        ),


      ),
    );
  }

  signupFormWidget({required BuildContext context, required Size size}) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            LogoText(firstText: "TODAY", secondText: "NEWS"),
        const SizedBox(
          height: 20,
        ),
            SizedBox(
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
                    ))),
          ],
        ));
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
          const SizedBox(
            height: 10,
          ),
          PhoneNumberInputField(
            controller: phoneNumberController,
            hintText: 'Enter phone number',
            size: size,
            textInputType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormFields(
              size: size,
              controller: passwordController,
              validator: passwordValidator,
              hintText: "Enter password",
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.text,
              obsecureText: isVisible,
              iconButton: IconButton(
                icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
                color: isVisible ? const Color(0xFFC3C2C2) : Colors.blue,
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
              )),
          const SizedBox(
            height: 15,
          ),
          CustomButton(
            size: size,
            text: 'Submit',
            radius: BorderRadius.circular(15),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  showLoading = true;
                });
                var response = await _authClass.signUp(
                    emailController.text,
                    passwordController.text,
                    nameController.text,
                    addressController.text,
                    "+91${phoneNumberController.text}",
                    context);
                await verifyPhoneNumber();
                const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          CustomTextButton(
            text: "Already have an account? Login",
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SignInPage()));
            },
            color: Colors.black,
          ),
        ],
      ),
    );
    
  }

  Future<void> verifyPhoneNumber() {
    return _auth.verifyPhoneNumber(
              phoneNumber: "+91${phoneNumberController.text}",
              // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
              verificationCompleted: (PhoneAuthCredential) async {
                setState(() {
                  showLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Phone number Verified")),
                    );
              },
              verificationFailed: (verificationFailed) async {
                setState(() {
                  showLoading = false;
                });
                Fluttertoast.showToast(
                    msg: "Please check your network/phone number");
              },
              codeSent: (
                verificationId,
                resendingToken,
              ) async {
                setState(() {
                  showLoading = false;
                  currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                  this.verificationId = verificationId;
                });
                Fluttertoast.showToast(msg: "Verification Code Sended");
              },
              codeAutoRetrievalTimeout: (verificationId) async {});
  }
  getOtpFormWidget(context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          LogoText(firstText: "TODAY", secondText: "NEWS"),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Enter OTP",
            style: TextStyle(
                fontFamily: "oswald", fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30,
          ),
          PinCodeTextField(
            maxLength: 6,
            autofocus: true,
            controller: otpController,
            defaultBorderColor: Colors.grey,
            hasTextBorderColor: Colors.green,
            onDone: (text) {
              print("DONE $text");
              print("Done Controller ${otpController.text}");

            },
            keyboardType: TextInputType.number,
            pinBoxWidth: 50,
            pinBoxHeight: 50,
            pinBoxRadius: 8,
          ),
          // TextField(
          //   controller: otpController,
          //   decoration: const InputDecoration(hintText: "Enter OTP"),
          // ),
          const SizedBox(
            height: 15,
          ),
          CustomButton(
            onPressed: () async {
              PhoneAuthCredential phoneAuthCredential =
                  PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: otpController.text);
              signInWithPhoneAuthCredential(phoneAuthCredential);
            },
            text: "verify",
            radius: BorderRadius.circular(15),
            size: size,
          ),
        ],
      ),
    );
  }

  void _listenOtp() async {
    await SmsAutoFill().listenForCode;
  }
}
