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
        elevation: 0.0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _isSignIn = true;
              });
            },
            child: Text(
              "ログイン",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Color(0xff000000)),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isSignIn = false;
              });
            },
            child: Text(
              "登録",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Color(0xff000000)),
            ),
          )
        ],
        bottom: PreferredSize(
            child: Container(
              color: Colors.black,
              height: 2.0,
            ),
            preferredSize: Size.fromHeight(2.0)),
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
