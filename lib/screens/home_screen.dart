import 'package:boxing_vote/screens/add_bout_info_screen.dart';
import 'package:flutter/material.dart';
import '../Tabs.dart';
import '../widgets/bout_list/bouts_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("近日開催予定の試合"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddBoutInfoScreen()))
              },
            ),
          ],
        ),
        body: BoutsList(),
        bottomNavigationBar: Tabs());
  }
}
