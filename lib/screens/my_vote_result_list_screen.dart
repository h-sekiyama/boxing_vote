import 'package:boxing_vote/widgets/bout_list/chat.dart';
import 'package:boxing_vote/widgets/other/my_vote_result_list.dart';
import 'package:flutter/material.dart';
import '../Tabs.dart';

class MyVoteResultListScreen extends StatelessWidget {
  MyVoteResultListScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [],
        ),
        body: MyVoteResultList(),
        bottomNavigationBar: Tabs());
  }
}
