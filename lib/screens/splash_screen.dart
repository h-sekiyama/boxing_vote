import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 画面の真ん中にグルグルを表示しておく
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
