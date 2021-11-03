import 'package:boxing_vote/screens/home_screen.dart';
import 'package:boxing_vote/widgets/auth/auth_check.dart';
import 'package:boxing_vote/widgets/bout_result/result_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Tabs.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [],
        ),
        body: ResultList(),
        bottomNavigationBar: Tabs());
  }
}
