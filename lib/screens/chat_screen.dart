import 'package:boxing_vote/widgets/chat.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/chat.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen(this.boutName);
  String boutName;

  Future<void> _signOut() async {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
      ),
      body: Chat(boutName),
    );
  }
}
