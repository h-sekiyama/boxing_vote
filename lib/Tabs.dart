import 'package:boxing_vote/screens/bout_detail_screen.dart';
import 'package:boxing_vote/screens/home_screen.dart';
import 'package:boxing_vote/screens/other_screen.dart';
import 'package:boxing_vote/screens/result_screen.dart';
import 'package:boxing_vote/widgets/bout_list/bouts_detail.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Functions.dart';
import '../screens/chat_screen.dart';

class Tabs extends StatefulWidget {
  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<Tabs> {
  static int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.rule),
          title: Text('勝敗予想'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          title: Text('試合結果'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text('その他'),
        ),
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
            currentIndex = index;
            break;
          case 1:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ResultScreen()));
            currentIndex = index;
            break;
          case 2:
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => OtherScreen()));
            currentIndex = index;
            break;
        }
      },
      selectedItemColor: Colors.blue,
      currentIndex: currentIndex,
    );
  }
}
