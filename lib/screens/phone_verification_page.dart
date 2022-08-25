import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/input_form_field.dart';
import 'home.dart';

enum MobileVerificationState{
  // ignore: constant_identifier_names
  SHOW_MOBILE_FORM_STATE,
  // ignore: constant_identifier_names
  SHOW_OTP_FORM_STATE,
}

class PhoneVerificationPage extends StatefulWidget {
  
  PhoneVerificationPage({Key? key}) : super(key: key);

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  MobileVerificationState currentState = MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final otpController = TextEditingController(); 
  final phoneNumberController = TextEditingController();

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
    Size size = MediaQuery.of(context).size;
    return Column(
      children:  [
        Text("Verify Your Number",style: TextStyle(fontFamily: "oswald",fontSize: 25,fontWeight: FontWeight.bold),),
        SizedBox(height: 45,),
        TextField(
          controller: phoneNumberController,
          decoration: InputDecoration(hintText: "enter phone number"),
        ),
        // PhoneNumberInputField(
        //   size: size,
        //   controller: phoneNumberController,
        //   hintText: "Enter Phone Number",
        //   textInputAction: TextInputAction.send,
        //   textInputType: TextInputType.phone),
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
              print(phoneNumberController.text);
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.yellow,
      key: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.only(
              top: size.height * 0.1,
              left: size.width * 0.04,
              right: size.width * 0.04),
        child: showLoading ? Center(child: CircularProgressIndicator(),) : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE?
      getMobileFormWidget(context):getOtpFormWidget(context),
      )
    );
  }
}