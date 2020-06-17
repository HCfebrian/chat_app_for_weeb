import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginButton(),
    );
  }

  Widget loginButton() {
    return FlatButton(
      child: Text(
        "Sign In",
        style: TextStyle(
            fontSize: 35, fontWeight: FontWeight.w900, letterSpacing: 9),
      ),
      onPressed: () => performLogin(),
    );
  }

  void performLogin() {}
}
