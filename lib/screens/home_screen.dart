import 'package:boxing_vote/screens/add_bout_info_screen.dart';
import 'package:flutter/material.dart';
import '../common/Tabs.dart';
import '../widgets/bout_list/bouts_list.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen(this.isList, this.sports);
  bool isList; // 試合一覧画面か否か
  String sports = ""; // 選択中の種目
  String headerText = "";

  @override
  Widget build(BuildContext context) {
    headerText = isList ? "試合予定（${sports}）" : "試合結果（${sports}）";
    return Scaffold(
        appBar: AppBar(
          title: Text('${headerText}'),
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
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  '競技を選ぶ',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('全て'),
                tileColor:
                    sports == "全て" ? Color(0xffaa00aa) : Color(0xffffffff),
                onTap: () {
                  sports = "全て";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(isList, sports),
                      ));
                },
              ),
              ListTile(
                title: Text('ボクシング'),
                tileColor:
                    sports == "ボクシング" ? Color(0xffaa00aa) : Color(0xffffffff),
                onTap: () {
                  sports = "ボクシング";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(isList, sports),
                      ));
                },
              ),
              ListTile(
                title: Text('K-1'),
                tileColor:
                    sports == "K-1" ? Color(0xffaa00aa) : Color(0xffffffff),
                onTap: () {
                  sports = "K-1";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(isList, sports),
                      ));
                },
              ),
              ListTile(
                title: Text('RIZIN'),
                tileColor:
                    sports == "RIZIN" ? Color(0xffaa00aa) : Color(0xffffffff),
                onTap: () {
                  sports = "RIZIN";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(isList, sports),
                      ));
                },
              ),
            ],
          ),
        ),
        body: BoutsList(isList, sports),
        bottomNavigationBar: Tabs());
  }
}
