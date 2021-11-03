import 'package:boxing_vote/widgets/bout_list/add_bout_info.dart';
import 'package:boxing_vote/widgets/other/profile.dart';
import 'package:flutter/material.dart';
import '../Tabs.dart';

class AddBoutInfoScreen extends StatelessWidget {
  AddBoutInfoScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("試合情報追加"),
          actions: [],
        ),
        body: AddBoutInfo(),
        bottomNavigationBar: Tabs());
  }
}
