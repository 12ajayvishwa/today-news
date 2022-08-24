import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum MobileVerificationState{
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  MobileVerificationState currentState = MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final phoneNumberController = TextEditingController();
  final otpController = TextEditingController(); 

  FirebaseAuth _auth = FirebaseAuth.instance;

  late String verificationId;
  

  getMobileFormWidget(context){
    return Column(
      children:  [
        Spacer(),
        TextField(
          controller: phoneNumberController,
          decoration: InputDecoration(hintText: "Phone Number"),
        ),
        SizedBox(height: 16,),
        FlatButton(onPressed: () async {
          await _auth.verifyPhoneNumber(
            phoneNumber: phoneNumberController.text,
            verificationCompleted: (PhoneAuthCredential) async {

            }, 
            verificationFailed: (verificationFailed) async {

            }, 
            codeSent: (verificationId,resendingToken) async {
              setState(() {
                currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                this.verificationId = verificationId;
              });
            }, 
            codeAutoRetrievalTimeout: (verificationId) async {

            });
        }, 
        child: Text("SEND"),
        color: Colors.blue,
        textColor: Colors.white,),
        Spacer()
      ],
    );
  }

  getOtpFormWidget(context){
    return Column(
      children:  [
        const Spacer(),
        TextField(
          controller: otpController,
          decoration: const InputDecoration(hintText: "Enter OTP"),
        ),
        const SizedBox(height: 16,),
        FlatButton(onPressed: () {}, 
        child: Text("verify"),
        color: Colors.blue,
        textColor: Colors.white,),
        Spacer()
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE?
      getMobileFormWidget(context):getOtpFormWidget(context),
      padding: const EdgeInsets.all(16),
      )
    );
  }
}