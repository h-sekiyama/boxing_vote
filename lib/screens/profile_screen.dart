import 'package:boxing_vote/widgets/other/profile.dart';
import 'package:flutter/material.dart';
import '../common/Tabs.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("プロフィール設定"),
          actions: [],
        ),
        body: Profile(),
        bottomNavigationBar: Tabs());
  }
}
