import 'package:boxing_vote/common/Functions.dart';
import 'package:boxing_vote/common/HexColor.dart';
import 'package:boxing_vote/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VoteResultList extends StatefulWidget {
  VoteResultList(this.userId);
  String userId;
  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<VoteResultList> {
  // ユーザー名
  String userName = "";
  // 累計予想試合数
  int totalVoteBoutCount = 0;
  // 累計予想試合数（集計済み）
  int endTotalVoteBoutCount = 0;
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
  // FireStoreのインスタンス
  FirebaseStorage storage = FirebaseStorage.instance;
  // プロフ画像のURL
  String imageUrl = "";
  // ユーザーアイコン
  Image? nowImage;

  void initState() {
    fetchBoutResultsData();
    downloadImage();
  }

  @override
  Widget build(BuildContext context) {
    userName = (widget.userId == FirebaseAuth.instance.currentUser!.uid
        ? FirebaseAuth.instance.currentUser!.displayName
        : userName)!;
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Column(children: [
              ListTile(
                  leading: _displaySelectionImageOrGrayImage(),
                  title: Text('${userName}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${title}')),
              Text(
                  '全予想試合数：${totalVoteBoutCount}\n集計済み試合数：${endTotalVoteBoutCount}\n的中試合数：${wonBoutCount}\n的中率：${wonBoutRate.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ))
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(4, 12, 4, 6),
                        child: Text(
                            Functions.dateToString(fight_date) +
                                " / " +
                                document['event_name'],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(4, 8, 4, 10),
                        width: MediaQuery.of(context).size.width * 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                                child: Text(document['fighter1'],
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
                            Flexible(
                                child: Text(document['fighter2'],
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
                                : 0,
                            backgroundColor: Color(0xff4B9EFF),
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.red),
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
                      // 予想結果
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("予想：" + votedText,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ]),
                      // 試合結果
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("結果：" + resultText,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffFF7A00))),
                          ]),
                      Container(
                          width: 187,
                          height: 38,
                          margin: EdgeInsets.fromLTRB(0, 8, 0, 30),
                          child: (TextButton(
                            child: const Text('この試合について語る',
                                style: TextStyle(fontWeight: FontWeight.bold)),
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
                            },
                          ))),
                    ]),
                  ),
                );
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
        .doc(widget.userId)
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
                      docs["result"] == votedBoutsList[docs.id] &&
                      docs["result"] != 0) {
                    wonBoutCount++;
                  }
                  // 結果の出ている予想試合数を集計
                  if (docs['result'] != 0 &&
                      docs['result'] != -1 &&
                      votedBoutsList.containsKey(docs.id)) {
                    endTotalVoteBoutCount++;
                  }
                  // 試合リスト作成（予想してない or 削除になった試合はリストから外す
                  if (votedBoutsList.containsKey(docs.id) &&
                      votedBoutsList[docs.id] != -1) {
                    boutList.add(docs);
                  }
                });
              }),
              setState(() {
                totalVoteBoutCount = votedBoutsList.length;
                wonBoutCount = wonBoutCount;
                wonBoutRate = endTotalVoteBoutCount != 0
                    ? wonBoutCount / endTotalVoteBoutCount * 100
                    : 0;
                title = Functions.getTitle(
                    endTotalVoteBoutCount, wonBoutCount, wonBoutRate);
                boutList = boutList;
                userName = ref['name'];
              })
            });
  }

  // アイコン画像のダウンロード
  void downloadImage() async {
    try {
      Reference imageRef = storage
          .ref()
          .child("profile")
          .child("${FirebaseAuth.instance.currentUser!.uid}.png");
      imageUrl = await imageRef.getDownloadURL();

      // 画面に反映
      setState(() {
        nowImage = Image.network(imageUrl);
      });
    } catch (FirebaseException) {
      print(FirebaseException);
    }
  }

  Widget _displaySelectionImageOrGrayImage() {
    if (nowImage != null) {
      return Container(
        width: 60,
        height: 80,
        child: ClipRRect(
          child: nowImage,
        ),
      );
    } else {
      return Container(
        width: 60,
        height: 80,
        child: ClipRRect(
          child: Image.asset('images/cat.png'),
        ),
      );
    }
  }
}
