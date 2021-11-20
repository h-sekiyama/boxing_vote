import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../screens/home_screen.dart';
import '../../screens/auth_screen.dart';

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _showErrorFlash(String message) {
      Flushbar(
        message: message,
        backgroundColor: Colors.red,
        margin: EdgeInsets.all(8),
        duration: Duration(seconds: 3),
      )..show(context);
    }

    final auth = FirebaseAuth.instance.currentUser;
    if (auth != null) {
      final isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      if (isVerified) {
        return HomeScreen(true, "全て");
      } else {
        return AuthScreen(true);
      }
    } else {
      return AuthScreen(true);
    }
  }
}
