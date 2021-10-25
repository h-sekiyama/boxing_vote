import 'package:boxing_vote/widgets/bouts_detail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/bouts_list.dart';

class BoutDetailScreen extends StatelessWidget {
  BoutDetailScreen(this.id);
  String id;

  Future<void> _signOut() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            onPressed: _signOut,
            child: Text(
              "サインアウト",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: BoutDetail(id),
    );
  }
}
