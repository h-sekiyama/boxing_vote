import 'package:boxing_vote/widgets/bout_list/bouts_vote.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../common/Tabs.dart';
import '../widgets/bout_list/bouts_list.dart';

class BoutVoteScreen extends StatelessWidget {
  BoutVoteScreen(this.id);
  String id;

  Future<void> _signOut() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          actions: [],
          title: Text("勝敗予想", style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: PreferredSize(
              child: Container(
                color: Colors.black,
                height: 2.0,
              ),
              preferredSize: Size.fromHeight(2.0)),
        ),
        body: BoutVote(id),
        bottomNavigationBar: Tabs());
  }
}
