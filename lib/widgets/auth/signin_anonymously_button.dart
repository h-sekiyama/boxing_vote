import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInAnonymouslyButton extends StatefulWidget {
  @override
  _SignInAnonymouslyButtonState createState() =>
      _SignInAnonymouslyButtonState();
}

class _SignInAnonymouslyButtonState extends State<SignInAnonymouslyButton> {
  bool _isLoading = false;

  Future<void> _signInAnonymously() async {
    setState(() {
      _isLoading = true;
    });
    await FirebaseAuth.instance.signInAnonymously();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ElevatedButton.icon(
            onPressed: _signInAnonymously,
            icon: Icon(Icons.account_box),
            label: Text("匿名サインイン"),
          );
  }
}
