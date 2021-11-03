import 'package:boxing_vote/screens/my_vote_result_list_screen.dart';
import 'package:boxing_vote/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddBoutInfo extends StatefulWidget {
  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<AddBoutInfo> {
  String eventName = "";
  String fighter1 = "";
  String fighter2 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text("試合予定を追加する事ができます。皆さんが勝敗予想を楽しめる様、正しい試合情報を投稿して頂けます様にお願い致します。"),
            TextFormField(
              autofocus: false,
              style: new TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              decoration: new InputDecoration(
                hintText: '大会名',
              ),
              onChanged: (value) {
                eventName = value;
              },
            ),
            TextFormField(
              autofocus: false,
              style: new TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              decoration: new InputDecoration(
                hintText: '選手1氏名',
              ),
              onChanged: (value) {
                fighter1 = value;
              },
            ),
            TextFormField(
              autofocus: false,
              style: new TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              decoration: new InputDecoration(
                hintText: '選手2氏名',
              ),
              onChanged: (value) {
                fighter2 = value;
              },
            ),
            Column(children: [
              ElevatedButton(
                child: Text("追加する"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
              )
            ]),
          ],
        ),
      ),
    );
  }
}
