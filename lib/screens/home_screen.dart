import 'package:boxing_vote/common/Functions.dart';
import 'package:boxing_vote/screens/add_bout_info_screen.dart';
import 'package:boxing_vote/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import '../common/Tabs.dart';
import '../widgets/bout_list/bouts_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen(this.isList, this.sports);
  bool isList; // 試合一覧画面か否か
  String? sports = "全て"; // 選択中の種目
  String headerText = "";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          headerText = isList
              ? "試合予定（${snapshot.data ?? "全て"}）"
              : "試合結果（${snapshot.data ?? "全て"}）";
          sports = snapshot.data ?? "全て";
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
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
                      tileColor: sports == "全て"
                          ? Color(0xffFFF9B5)
                          : Color(0xffffffff),
                      onTap: () {
                        sports = "全て";
                        saveData(sports!);
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
                      tileColor: sports == "ボクシング"
                          ? Color(0xffFFF9B5)
                          : Color(0xffffffff),
                      onTap: () {
                        sports = "ボクシング";
                        saveData(sports!);
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
                      tileColor: sports == "K-1"
                          ? Color(0xffFFF9B5)
                          : Color(0xffffffff),
                      onTap: () {
                        sports = "K-1";
                        saveData(sports!);
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
                      tileColor: sports == "RIZIN"
                          ? Color(0xffFFF9B5)
                          : Color(0xffffffff),
                      onTap: () {
                        sports = "RIZIN";
                        saveData(sports!);
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
              body: snapshot.data != null
                  ? BoutsList(isList, snapshot.data ?? "全て")
                  : null,
              bottomNavigationBar: Tabs());
        });
  }

  // 選択中種目をユーザー保存領域に保存
  saveData(String sports) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("sports", sports);
  }

// 選択中種目をユーザー保存領域から取得
  Future<String> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("sports") ?? "全て";
  }
}
