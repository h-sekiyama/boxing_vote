import 'package:boxing_vote/widgets/auth/forget_password.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("パスワード変更"),
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
        child: ForgetPassword(),
      ),
    );
  }
}
