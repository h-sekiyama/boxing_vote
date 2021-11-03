import 'package:boxing_vote/widgets/other/profile.dart';
import 'package:flutter/material.dart';
import '../Tabs.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [],
        ),
        body: Profile(),
        bottomNavigationBar: Tabs());
  }
}
