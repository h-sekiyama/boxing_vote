import 'package:boxing_vote/widgets/bout_list/add_bout_info.dart';
import 'package:boxing_vote/widgets/other/profile.dart';
import 'package:flutter/material.dart';
import '../common/Tabs.dart';

class AddBoutInfoScreen extends StatelessWidget {
  AddBoutInfoScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text("試合情報追加", style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [],
          bottom: PreferredSize(
              child: Container(
                color: Colors.black,
                height: 2.0,
              ),
              preferredSize: Size.fromHeight(2.0)),
        ),
        body: AddBoutInfo(),
        bottomNavigationBar: Tabs());
  }
}
