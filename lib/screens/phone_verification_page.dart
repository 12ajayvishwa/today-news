import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todaynews/widgets/custom_button.dart';
import 'package:todaynews/widgets/logo_text.dart';
import '../widgets/input_form_field.dart';
import 'home/dashboard.dart';

enum MobileVerificationState {
  // ignore: constant_identifier_names
  SHOW_MOBILE_FORM_STATE,
  // ignore: constant_identifier_names
  SHOW_OTP_FORM_STATE,
}

class PhoneVerificationPage extends StatefulWidget {
  const PhoneVerificationPage({Key? key}) : super(key: key);

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final otpController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String verificationId;

  bool showLoading = false;
  String smsCode = "";

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
            context, MaterialPageRoute(builder: (context) => const Dashboard()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      Fluttertoast.showToast(msg: e.message as String);
    }
  }

  getMobileFormWidget(context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        LogoText(firstText: "TODAY", secondText: "NEWS"),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Verify Your Number",
          style: TextStyle(
              fontFamily: "oswald", fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 30,
        ),
        PhoneNumberInputField(
            size: size,
            controller: phoneNumberController,
            hintText: "Enter Phone Number",
            textInputAction: TextInputAction.send,
            textInputType: TextInputType.phone),
        const SizedBox(
          height: 16,
        ),
        CustomButton(
          onPressed: () async {
            setState(() {
              showLoading = true;
            });
            await _auth.verifyPhoneNumber(
                phoneNumber: "+91 ${phoneNumberController.text}",
                // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
                verificationCompleted: (PhoneAuthCredential) async {
                  setState(() {
                    showLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Phone number Verified")));
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
          },
          text: "Continue",
          radius: BorderRadius.circular(15),
          size: size,
        ),
        const Spacer()
      ],
    );
  }

  getOtpFormWidget(context) {
    Size size = MediaQuery.of(context).size;
    return Column(
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
        TextField(
          controller: otpController,
          decoration: const InputDecoration(hintText: "Enter OTP"),
        ),
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
        const Spacer()
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
            padding: EdgeInsets.only(
                top: size.height * 0.1,
                left: size.width * 0.04,
                right: size.width * 0.04),
            child: showLoading
                ? Center(
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
                  )
                : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                    ? getMobileFormWidget(context)
                    : getOtpFormWidget(context)));
  }
}
