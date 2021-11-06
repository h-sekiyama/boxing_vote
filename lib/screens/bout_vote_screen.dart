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
          actions: [],
        ),
        body: BoutVote(id),
        bottomNavigationBar: Tabs());
  }
}
