import 'package:boxing_vote/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'widgets/auth/auth_check.dart';

void main() async {
  // これがないとエラーが出ます
  WidgetsFlutterBinding.ensureInitialized();
  // Firebaseのサービスを使う前に初期化を行います
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '格闘技勝敗予想アプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(true, "全て"),
    );
  }
}
