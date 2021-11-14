import 'package:boxing_vote/widgets/bout_list/chat.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../common/Tabs.dart';
import '../widgets/bout_list/chat.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen(this.boutId);
  String boutId;

  Future<void> _signOut() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          actions: [],
          title: Text("チャット", style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: PreferredSize(
              child: Container(
                color: Colors.black,
                height: 2.0,
              ),
              preferredSize: Size.fromHeight(2.0)),
        ),
        body: Chat(boutId),
        bottomNavigationBar: Tabs());
  }
}
