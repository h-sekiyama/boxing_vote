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
          actions: [],
        ),
        body: Chat(boutId),
        bottomNavigationBar: Tabs());
  }
}
