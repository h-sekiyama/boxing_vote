import 'package:boxing_vote/common/Functions.dart';
import 'package:boxing_vote/screens/add_bout_info_screen.dart';
import 'package:boxing_vote/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import '../common/Tabs.dart';
import '../widgets/bout_list/bouts_list.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen(this.isList, this.sports);
  bool isList; // 試合一覧画面か否か
  String sports = "全て"; // 選択中の種目
  String headerText = "";

  @override
  Widget build(BuildContext context) {
    headerText = isList ? "試合予定（${sports}）" : "試合結果（${sports}）";
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text("${headerText}",
              style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            Row(children: [
              Visibility(
                  visible: isList && Functions.checkLogin(),
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddBoutInfoScreen()))
                    },
                  )),
              Visibility(
                visible: !Functions.checkLogin(),
                child: TextButton(
                  child: const Text('ログイン',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color(0xff000000))),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AuthScreen(false)));
                  },
                ),
              )
            ])
          ],
          bottom: PreferredSize(
              child: Container(
                color: Colors.black,
                height: 2.0,
              ),
              preferredSize: Size.fromHeight(2.0)),
        ),
        drawer: Drawer(
            child: Container(
          child: ListView(
            children: <Widget>[
              Container(
                  color: Colors.white,
                  height: 200,
                  child: DrawerHeader(
                    child: Column(children: [
                      Container(
                          margin: EdgeInsets.only(top: 12, bottom: 12),
                          child: Center(
                            child: Text("ボクシング・K-1・RIZINの\n勝敗予想投票アプリ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )),
                      Image(
                        width: MediaQuery.of(context).size.width * 0.85,
                        image: AssetImage('images/logo.png'),
                      ),
                    ]),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                  )),
              Container(
                color: Colors.black,
                child: Text("競技を選ぶ",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white)),
              ),
              ListTile(
                title: Text('全て'),
                tileColor:
                    sports == "全て" ? Color(0xffFFF9B5) : Color(0xffffffff),
                onTap: () {
                  sports = "全て";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(isList, sports),
                      ));
                },
              ),
              Container(
                height: 1,
                color: Colors.black,
              ),
              ListTile(
                title: Text('ボクシング'),
                tileColor:
                    sports == "ボクシング" ? Color(0xffFFF9B5) : Color(0xffffffff),
                onTap: () {
                  sports = "ボクシング";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(isList, sports),
                      ));
                },
              ),
              Container(
                height: 1,
                color: Colors.black,
              ),
              ListTile(
                title: Text('K-1'),
                tileColor:
                    sports == "K-1" ? Color(0xffFFF9B5) : Color(0xffffffff),
                onTap: () {
                  sports = "K-1";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(isList, sports),
                      ));
                },
              ),
              Container(
                height: 1,
                color: Colors.black,
              ),
              ListTile(
                title: Text('RIZIN'),
                tileColor:
                    sports == "RIZIN" ? Color(0xffFFF9B5) : Color(0xffffffff),
                onTap: () {
                  sports = "RIZIN";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(isList, sports),
                      ));
                },
              ),
              Container(
                height: 1,
                color: Colors.black,
              ),
            ],
          ),
        )),
        body: BoutsList(isList, sports),
        bottomNavigationBar: Tabs());
  }
}
