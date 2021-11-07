import 'package:boxing_vote/widgets/bout_list/send_bouts_result.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../common/Tabs.dart';

// 試合結果を報告する画面（投票期間終了後で、試合結果集計中時のみ表示）
class SendBoutResultScreen extends StatelessWidget {
  SendBoutResultScreen(this.id);
  String id;

  Future<void> _signOut() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("試合結果報告"),
          actions: [],
        ),
        body: SendBoutResult(id),
        bottomNavigationBar: Tabs());
  }
}
