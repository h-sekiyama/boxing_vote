import 'package:boxing_vote/widgets/bout_list/chat.dart';
import 'package:boxing_vote/widgets/other/vote_result_list.dart';
import 'package:flutter/material.dart';
import '../common/Tabs.dart';

class VoteResultListScreen extends StatelessWidget {
  VoteResultListScreen(this.isOwn);
  bool isOwn; // 自分の勝敗予想リストか

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("予想結果一覧"),
          actions: [],
        ),
        body: VoteResultList(isOwn),
        bottomNavigationBar: Tabs());
  }
}
