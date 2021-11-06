import 'package:boxing_vote/screens/add_bout_info_screen.dart';
import 'package:flutter/material.dart';
import '../Tabs.dart';
import '../widgets/bout_list/bouts_list.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen(this.isList);
  bool isList; // 試合一覧画面か否か
  String headerText = "";

  @override
  Widget build(BuildContext context) {
    headerText = isList ? "近日開催予定の試合" : "試合結果一覧";
    return Scaffold(
        appBar: AppBar(
          title: Text('${headerText}'),
          automaticallyImplyLeading: false,
          actions: [
            Visibility(
                visible: isList,
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddBoutInfoScreen()))
                  },
                ))
          ],
        ),
        body: BoutsList(isList),
        bottomNavigationBar: Tabs());
  }
}
