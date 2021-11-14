import 'package:boxing_vote/widgets/other/other.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../common/Tabs.dart';

class OtherScreen extends StatelessWidget {
  OtherScreen();

  Future<void> _signOut() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text("その他", style: TextStyle(fontWeight: FontWeight.bold)),
          automaticallyImplyLeading: false,
          actions: [],
          bottom: PreferredSize(
              child: Container(
                color: Colors.black,
                height: 2.0,
              ),
              preferredSize: Size.fromHeight(2.0)),
        ),
        body: Other(),
        bottomNavigationBar: Tabs());
  }
}
