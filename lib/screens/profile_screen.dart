import 'package:boxing_vote/widgets/other/profile.dart';
import 'package:flutter/material.dart';
import '../common/Tabs.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title:
              Text("プロフィール設定", style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [],
          bottom: PreferredSize(
              child: Container(
                color: Colors.black,
                height: 2.0,
              ),
              preferredSize: Size.fromHeight(2.0)),
        ),
        body: Profile(),
        bottomNavigationBar: Tabs());
  }
}
