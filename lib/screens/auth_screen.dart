import 'package:flutter/material.dart';
import '../widgets/auth/email_sign_up_form.dart';
import '../widgets/auth/email_sign_in_form.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen(this.isRegister);
  bool isRegister;

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isRegister ? Text("新規登録") : Text("ログイン"),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
            child: Container(
              color: Colors.black,
              height: 2.0,
            ),
            preferredSize: Size.fromHeight(2.0)),
      ),
      body: Center(
        child: widget.isRegister
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [EmailSignUpForm()],
              )
            : EmailSignInForm(),
      ),
    );
  }
}
