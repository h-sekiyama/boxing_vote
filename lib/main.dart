import 'package:boxing_vote/common/HexColor.dart';
import 'package:boxing_vote/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
        primarySwatch: Common.primaryColor,
        accentColor: Common.accentColor,
        primaryIconTheme: IconThemeData(color: Colors.black),
        scaffoldBackgroundColor: Common.scaffoldBackgroundColor,
      ),
      home: HomeScreen(true, "全て"),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("en"),
        const Locale("ja"),
      ],
    );
  }
}

class Common {
  static const int _primaryValue = 0xffffffff;
  static const MaterialColor primaryColor = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(_primaryValue),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );

  static const int _accentValue = 0xff642517;
  static const MaterialColor accentColor =
      MaterialColor(_accentValue, <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(_accentValue),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  });

  static const int _scaffoldBackgroundValue = 0xffFFE574;
  static const MaterialColor scaffoldBackgroundColor = MaterialColor(
    _scaffoldBackgroundValue,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(_scaffoldBackgroundValue),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );
}
