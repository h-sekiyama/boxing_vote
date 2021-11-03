import 'package:boxing_vote/widgets/other/other.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Tabs.dart';

class OtherScreen extends StatelessWidget {
  OtherScreen();

  Future<void> _signOut() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("その他"),
          automaticallyImplyLeading: false,
          actions: [],
        ),
        body: Other(),
        bottomNavigationBar: Tabs());
  }
}
