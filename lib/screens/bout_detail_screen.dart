import 'package:boxing_vote/widgets/bout_list/bouts_detail.dart';
import 'package:flutter/material.dart';
import '../common/Tabs.dart';

class BoutDetailScreen extends StatelessWidget {
  BoutDetailScreen(this.boutId, this.isDetail);
  String boutId;
  bool isDetail; // 勝敗予想詳細画面か否か

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text("試合詳細", style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [],
          bottom: PreferredSize(
              child: Container(
                color: Colors.black,
                height: 2.0,
              ),
              preferredSize: Size.fromHeight(2.0)),
        ),
        body: BoutDetail(boutId, isDetail),
        bottomNavigationBar: Tabs());
  }
}
