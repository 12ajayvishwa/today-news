import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';

enum MobileVerificationState{
  // ignore: constant_identifier_names
  SHOW_MOBILE_FORM_STATE,
  // ignore: constant_identifier_names
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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String verificationId;

  bool showLoading = false;

  void signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try{
      final authCredential = 
            await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });

      if(authCredential?.user != null){
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(e.message as String)));
    }
  }
  

  getMobileFormWidget(context){
    return Column(
      children:  [
        const Spacer(),
        TextField(
          controller: phoneNumberController,
          decoration: const InputDecoration(hintText: "Phone Number"),
        ),
        const SizedBox(height: 16,),
        FlatButton(onPressed: () async {
          setState(() {
            showLoading = true;
          });
          await _auth.verifyPhoneNumber(
            phoneNumber: phoneNumberController.text,
            verificationCompleted: (PhoneAuthCredential) async {
              setState(() {
                showLoading = false;
              });
            }, 
            verificationFailed: (verificationFailed) async {
              setState(() {
                showLoading = false;
              });
              _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(verificationFailed.message as String)));
            }, 
            codeSent: (verificationId,resendingToken) async {
              setState(() {
                showLoading = false;
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
        FlatButton(onPressed: () async {
          PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpController.text);
          signInWithPhoneAuthCredential(phoneAuthCredential);
        }, 
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
        child: showLoading ? Center(child: CircularProgressIndicator(),) : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE?
      getMobileFormWidget(context):getOtpFormWidget(context),
      padding: const EdgeInsets.all(16),
      )
    );
  }
}