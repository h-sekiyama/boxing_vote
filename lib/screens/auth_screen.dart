import 'package:flutter/material.dart';
import '../widgets/auth/email_sign_up_form.dart';
import '../widgets/auth/email_sign_in_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isSignIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isSignIn = true;
              });
            },
            child: Text(
              "サインイン",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isSignIn = false;
              });
            },
            child: Text(
              "登録",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: _isSignIn
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [EmailSignInForm()],
              )
            : EmailSignUpForm(),
      ),
    );
  }
}
