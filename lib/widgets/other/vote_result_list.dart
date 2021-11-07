import 'package:boxing_vote/common/Functions.dart';
import 'package:boxing_vote/common/HexColor.dart';
import 'package:boxing_vote/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VoteResultList extends StatefulWidget {
  VoteResultList(this.isOwn);
  bool isOwn;
  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<VoteResultList> {
  // 累計予想試合数
  int totalVoteBoutCount = 0;
  // 的中試合数
  int wonBoutCount = 0;
  // 的中率
  double wonBoutRate = 0;
  // 投票済み試合リスト
  var votedBoutsList;
  // 投票済み試合で結果が出ている試合リスト
  var votedResultList;
  // 称号
  String title = "";
  // 試合情報を入れる箱を用意
  List<DocumentSnapshot> boutList = [];

  void initState() {
    fetchBoutResultsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Column(children: [
              ListTile(
                  leading: Image.asset('images/cat.png'),
                  title:
                      Text('${FirebaseAuth.instance.currentUser!.displayName}'),
                  subtitle: Text('${title}')),
              Text(
                  '予想試合数：${totalVoteBoutCount}\n的中試合数：${wonBoutCount}\n的中率：${wonBoutRate}%')
            ]),
            // ドキュメント情報を表示
            Expanded(
                child: ListView(
              scrollDirection: Axis.vertical,
              children: boutList.map((document) {
                DateTime fight_date = DateTime.now();
                if (document['fight_date'] is Timestamp) {
                  fight_date = document["fight_date"].toDate();
                }

                // その試合の総投票数
                int totalVotedCount = document["vote1"] +
                    document["vote2"] +
                    document["vote3"] +
                    document["vote4"];

                // その試合の自分の予想
                String votedText = "";
                if (votedBoutsList[document.id] == 1) {
                  votedText = "${document['fighter1']}のKO/TKO/一本勝ち";
                } else if (votedBoutsList[document.id] == 2) {
                  votedText = "${document['fighter1']}の判定勝ち";
                } else if (votedBoutsList[document.id] == 3) {
                  votedText = "${document['fighter2']}のKO/TKO/一本勝ち";
                } else if (votedBoutsList[document.id] == 4) {
                  votedText = "${document['fighter2']}の判定勝ち";
                }

                // その試合の結果
                String resultText = "";
                if (document['result'] == 0) {
                  resultText = "結果未集計";
                } else if (document['result'] == 1) {
                  resultText = "${document['fighter1']}のKO/TKO/一本勝ち";
                } else if (document['result'] == 2) {
                  resultText = "${document['fighter1']}の判定勝ち";
                } else if (document['result'] == 3) {
                  resultText = "${document['fighter2']}のKO/TKO/一本勝ち";
                } else if (document['result'] == 4) {
                  resultText = "${document['fighter2']}の判定勝ち";
                } else if (document['result'] == 99) {
                  resultText = "引き分けまたは無効試合";
                }
                return Visibility(
                    // 投票数が10件以上で、間違い情報がそれより多い試合情報は表示しない
                    visible: document["wrong_info_count"] < totalVotedCount ||
                        totalVotedCount < 10,
                    child: Card(
                      child: Column(children: [
                        ListTile(
                          title: Text(
                              '${document['fighter1']} VS ${document['fighter2']}'),
                          subtitle: Text('${document['event_name']}'),
                          trailing: Text(Functions.dateToString(fight_date)),
                        ),
                        ListTile(
                            title: Text(
                                '${document['fighter1']}の勝ち予想：${document['vote1'] + document['vote2']}人\n${document['fighter2']}の勝ち予想：${document['vote3'] + document['vote4']}人',
                                style: TextStyle(fontSize: 14.0))),
                        // 予想結果
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("予想："),
                              Text(votedText,
                                  style: TextStyle(color: HexColor('ff0000'))),
                            ]),
                        // 試合結果
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("結果："),
                              Text(resultText,
                                  style: TextStyle(color: HexColor('ff0000'))),
                            ]),
                        ElevatedButton(
                          child: const Text('この試合について語る'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange,
                            onPrimary: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(document.id),
                                ));
                          },
                        ),
                      ]),
                    ));
              }).toList(),
            )),
          ],
        ),
      ),
    );
  }

  // 試合情報取得処理
  void fetchBoutResultsData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((ref) async => {
              await FirebaseFirestore.instance
                  .collection('bouts')
                  .get()
                  .then((snapshot) {
                votedBoutsList = ref["votes"];
                snapshot.docs.forEach((docs) {
                  // 的中数を集計
                  if (votedBoutsList.containsKey(docs.id) &&
                      docs["result"] == votedBoutsList[docs.id]) {
                    wonBoutCount++;
                  }
                  // そもそも予想してない試合はリストから外す
                  if (votedBoutsList.containsKey(docs.id) &&
                      votedBoutsList[docs.id] != -1) {
                    boutList.add(docs);
                  }
                });
              }),
              setState(() {
                totalVoteBoutCount = votedBoutsList.length;
                wonBoutCount = wonBoutCount;
                wonBoutRate = wonBoutCount / totalVoteBoutCount * 100;
                title = Functions.getTitle(
                    totalVoteBoutCount, wonBoutCount, wonBoutRate);
                boutList = boutList;
              })
            });
  }
}
