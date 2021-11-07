import 'package:boxing_vote/widgets/bout_list/chat.dart';
import 'package:boxing_vote/widgets/other/vote_result_list.dart';
import 'package:flutter/material.dart';
import '../common/Tabs.dart';

class VoteResultListScreen extends StatelessWidget {
  VoteResultListScreen(this.userId);
  String userId; // 予想試合一覧を表示するユーザーのID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("予想試合一覧"),
          actions: [],
        ),
        body: VoteResultList(userId),
        bottomNavigationBar: Tabs());
  }
}
