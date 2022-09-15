import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todaynews/screens/home/home.dart';
import 'package:todaynews/screens/signin_page.dart';
import 'package:todaynews/services/firebase/auth_services.dart';

class Linker extends StatefulWidget {
  const Linker({Key? key}) : super(key: key);

  @override
  State<Linker> createState() => _LinkerState();
}

enum AuthStatus { LoggedIn, NotLoggedIn, NotDetermined }

class _LinkerState extends State<Linker> {
  AuthStatus _authStatus = AuthStatus.NotDetermined;

  Future _checkAuthStatus() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;
    if(currentUser == null){
      setState(() {
        _authStatus = AuthStatus.NotLoggedIn;
      });
    }else{
      _authStatus = AuthStatus.LoggedIn;
    }
  }

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    switch(_authStatus){
      case AuthStatus.LoggedIn:return Home();
      break;
      case AuthStatus.NotLoggedIn:return SignInPage();
      break;
      case AuthStatus.NotDetermined:return SignInPage();
      break;
      default:return SignInPage();
    }
  }
}
