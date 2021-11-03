import 'package:boxing_vote/widgets/bouts_detail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/bouts_list.dart';

class BoutDetailScreen extends StatelessWidget {
  BoutDetailScreen(this.id);
  String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
      ),
      body: BoutDetail(id),
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
