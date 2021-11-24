import 'package:boxing_vote/common/HexColor.dart';
import 'package:boxing_vote/screens/bout_detail_screen.dart';
import 'package:boxing_vote/screens/send_bout_result_screen.dart';
import 'package:boxing_vote/widgets/auth/auth_check.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../common/Functions.dart';
import '../../screens/chat_screen.dart';

class BoutsList extends StatefulWidget {
  BoutsList(this.isList, this.sports);
  bool isList;
  String sports;

  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<BoutsList> {
  // 試合情報を入れる箱を用意
  List<DocumentSnapshot> boutList = [];
  // 結果文言
  String resultText = "";

  void initState() {
    fetchBoutData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: <Widget>[
          // 試合一覧を表示
          Expanded(
              child: ListView(
            scrollDirection: Axis.vertical,
            children: boutList.map((document) {
              DateTime fight_date = DateTime.now();
              if (document['fight_date'] is Timestamp) {
                fight_date = document["fight_date"].toDate();
              }
              if (document['result'] == 0) {
                resultText = "結果集計中";
              } else if (document['result'] == 1) {
                resultText = '${document['fighter1']}のKO/TKO/一本勝ち';
              } else if (document['result'] == 2) {
                resultText = '${document['fighter1']}の判定勝ち';
              } else if (document['result'] == 3) {
                resultText = '${document['fighter2']}のKO/TKO/一本勝ち';
              } else if (document['result'] == 4) {
                resultText = '${document['fighter2']}の判定勝ち';
              } else if (document['result'] == 99) {
                resultText = '引き分け/無効試合/反則';
              }

              // その試合の総投票数
              int totalVotedCount = document["vote1"] +
                  document["vote2"] +
                  document["vote3"] +
                  document["vote4"];
              return Visibility(
                  // 投票数が10件以上、または間違い情報が投票数＋５より少ない場合のみ表示
                  visible: document["wrong_info_count"] < totalVotedCount + 5 ||
                      totalVotedCount > 10,
                  child: GestureDetector(
                    onTap: Functions.checkLogin()
                        ? () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        // 試合結果画面からの遷移でかつ試合結果がまだ集計中の場合は投票画面に遷移、それ以外は試合詳細画面に遷移
                                        !widget.isList &&
                                                document['result'] == 0
                                            ? SendBoutResultScreen(document.id)
                                            : BoutDetailScreen(document.id,
                                                widget.isList))).then((value) {
                              // 遷移先から戻って来た際に再度試合情報を読み込む
                              fetchBoutData();
                            });
                          }
                        : () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AuthCheck()));
                          },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(8, 10, 8, 10),
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(8, 12, 8, 6),
                            child: Text(
                                Functions.dateToString(fight_date) +
                                    " / " +
                                    document['event_name'],
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(8, 8, 8, 10),
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.37,
                                    child: Text(document['fighter1'],
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                            color: Color(0xffFF4B4B)))),
                                Container(
                                    width: 50,
                                    child: Text('VS',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.37,
                                    child: Text(document['fighter2'],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                            color: Color(0xff4B9EFF)))),
                              ],
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              height: 8,
                              margin: EdgeInsets.fromLTRB(0, 12, 4, 4),
                              child: LinearProgressIndicator(
                                value: document['vote1']!.toDouble() +
                                            document['vote2']!.toDouble() +
                                            document['vote3']!.toDouble() +
                                            document['vote4']!.toDouble() !=
                                        0
                                    ? (document['vote1']!.toDouble() +
                                            document['vote2']!.toDouble()) /
                                        (document['vote1']!.toDouble() +
                                            document['vote2']!.toDouble() +
                                            document['vote3']!.toDouble() +
                                            document['vote4']!.toDouble())
                                    : 0.5,
                                backgroundColor: Color(0xff4B9EFF),
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.red),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(left: 14),
                                  child: Text(
                                      (document['vote1']! + document['vote2']!)
                                              .toString() +
                                          "人勝ち予想",
                                      textAlign: TextAlign.left)),
                              Container(
                                  margin: EdgeInsets.only(right: 14),
                                  child: Text(
                                      (document['vote3']! + document['vote4']!)
                                              .toString() +
                                          "人勝ち予想",
                                      textAlign: TextAlign.right))
                            ],
                          ),
                          Container(
                              width: 187,
                              height: 38,
                              margin: EdgeInsets.fromLTRB(0, 8, 0, 30),
                              child: (TextButton(
                                child: const Text('この試合について語る',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  primary: HexColor('000000'),
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChatScreen(document.id),
                                      ));
                                  fetchBoutData();
                                },
                              ))),
                        ]),
                      ),
                    ),
                  ));
            }).toList(),
          )),
          Visibility(
              visible: boutList.length == 0,
              child: Expanded(child: Text("試合情報がありません")))
        ],
      ),
    ));
  }

  void fetchBoutData() async {
    // 指定コレクションのドキュメント一覧を取得
    final snapshot;
    if (widget.sports == "全て") {
      snapshot = await FirebaseFirestore.instance
          .collection('bouts')
          .orderBy('fight_date', descending: !widget.isList)
          .get();
    } else {
      snapshot = await FirebaseFirestore.instance
          .collection('bouts')
          .orderBy('fight_date', descending: !widget.isList)
          .where('sports', isEqualTo: widget.sports)
          .get();
    }

    // ドキュメント一覧を配列で格納
    boutList = snapshot.docs;

    var serverTime;
    var serverTimeSnapshot;
    FirebaseFirestore.instance
        .collection("server_time")
        .doc("0")
        .set(({"serverTimeStamp": FieldValue.serverTimestamp()}))
        .then((value) async => {
              serverTimeSnapshot = await FirebaseFirestore.instance
                  .collection('server_time')
                  .doc("0")
                  .get(),
              serverTime =
                  (serverTimeSnapshot['serverTimeStamp'] as Timestamp).toDate(),
              if (widget.isList)
                {
                  boutList.removeWhere((document) =>
                      document["fight_date"].toDate().isBefore(serverTime))
                }
              else
                {
                  boutList.removeWhere((document) =>
                      document["fight_date"].toDate().isAfter(serverTime))
                },

              // ドキュメント一覧を配列で格納
              setState(() {
                boutList = boutList;
              })
            });
  }
}
