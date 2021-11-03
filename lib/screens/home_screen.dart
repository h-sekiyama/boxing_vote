import 'package:boxing_vote/widgets/auth/auth_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/bouts_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          FlatButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
            child: Text(
              "サインアウト",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: BoutsList(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
        ],
      ),
    );
  }
}
