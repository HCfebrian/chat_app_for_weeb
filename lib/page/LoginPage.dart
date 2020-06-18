import 'package:chatappforweeb/page/HomePage.dart';
import 'package:chatappforweeb/resources/firebase_repository.dart';
import 'package:chatappforweeb/utils/universal_variable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseRepository _repository = FirebaseRepository();
  bool isLoginPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Stack(children: [
        Center(child: loginButton()),
      ]),
    );
  }

  Widget loginButton() {
    if (isLoginPressed) {
      return Shimmer.fromColors(
        baseColor: Colors.white,
        highlightColor: UniversalVariables.senderColor,
        child: FlatButton(
          child: Text(
            "Sign In",
            style: TextStyle(
                fontSize: 35, fontWeight: FontWeight.w900, letterSpacing: 9),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () {},
        ),
      );
    } else {
      return FlatButton(
        child: Text(
          "Sign In",
          style: TextStyle(
              color: Colors.white,
              fontSize: 35,
              fontWeight: FontWeight.w900,
              letterSpacing: 9),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () => performLogin(),
      );
    }
  }

  void performLogin() {
    setState(() {
      isLoginPressed = true;
    });
    _repository.signIn().then((FirebaseUser firebaseUser) {
      if (firebaseUser != null) {
        authenticateUser(firebaseUser);
      } else {
        print("there is an error");
        setState(() {
          isLoginPressed = false;
        });
      }
    });
  }

  void authenticateUser(FirebaseUser user) {
    setState(() {
      isLoginPressed = false;
    });
    _repository.authenticateUser(user).then((isNewUser) {
      print("hasil is new user ${isNewUser.toString()}");
      if (isNewUser) {
        _repository.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomePage();
          }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      }
    });
  }
}
