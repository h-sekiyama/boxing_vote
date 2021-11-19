import 'package:boxing_vote/screens/auth_screen.dart';
import 'package:boxing_vote/screens/vote_result_list_screen.dart';
import 'package:boxing_vote/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Other extends StatefulWidget {
  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<Other> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Column(children: [
              Container(
                  width: 187,
                  height: 38,
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 14),
                  child: (TextButton(
                    child: Text("プロフィール設定",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen()));
                    },
                  ))),
              Container(
                  width: 187,
                  height: 38,
                  margin: EdgeInsets.fromLTRB(0, 8, 0, 14),
                  child: (TextButton(
                    child: Text("予想試合一覧",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VoteResultListScreen(
                                  FirebaseAuth.instance.currentUser!.uid)));
                    },
                  ))),
              Container(
                  width: 187,
                  height: 38,
                  margin: EdgeInsets.fromLTRB(0, 8, 0, 14),
                  child: (TextButton(
                    child: Text("ログアウト",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AuthScreen()));
                    },
                  ))),
            ]),
          ],
        ),
      ),
    );
  }
}
