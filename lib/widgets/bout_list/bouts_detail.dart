import 'package:boxing_vote/common/HexColor.dart';
import 'package:boxing_vote/screens/bout_vote_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../common/Functions.dart';

class BoutDetail extends StatefulWidget {
  BoutDetail(this.boutId, this.isDetail);
  String boutId;
  bool isDetail;

  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<BoutDetail> {
  // 興行名
  String boutName = "";
  // 選手1
  String fighter1 = "";
  // 選手2
  String fighter2 = "";
  // 試合日程テキスト
  String fightDateText = "";
  // 予想数Map（1：選手1のKO勝ち、2：選手1の判定勝ち、3：選手2のKO勝ち、4：選手2の判定勝ち）
  Map<int, int> voteCount = {1: 0, 2: 0, 3: 0, 4: 0};
  // 自分の予想（0：未投票、1：選手1のKO勝ち、2：選手1の判定勝ち、3：選手2のKO勝ち、4：選手2の判定勝ち）
  int myVote = 0;
  // 自分の予想（0：未投票、1：選手1のKO勝ち、2：選手1の判定勝ち、3：選手2のKO勝ち、4：選手2の判定勝ち, 99: 引き分け/無効試合）
  String myVoteText = "勝敗予想していません";
  // 試合結果
  String resultText = "集計中";
  // 試合の間違い報告数
  int wrongInfoCount = 0;
  // この試合に間違い報告済み
  bool isSentWrongInfo = false;

  void initState() {
    fetchBoutData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Column(children: [
              Container(
                margin: EdgeInsets.fromLTRB(4, 12, 4, 6),
                child: Text(fightDateText + " / " + boutName,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                child: Card(
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(4, 30, 4, 10),
                      width: MediaQuery.of(context).size.width * 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                              child: Text('${fighter1}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: Color(0xffFF4B4B)))),
                          Container(
                              width: 50,
                              child: Text('VS',
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Flexible(
                              child: Text('${fighter2}',
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
                          value: voteCount[1]!.toDouble() +
                                      voteCount[2]!.toDouble() +
                                      voteCount[3]!.toDouble() +
                                      voteCount[4]!.toDouble() !=
                                  0
                              ? (voteCount[1]!.toDouble() +
                                      voteCount[2]!.toDouble()) /
                                  (voteCount[1]!.toDouble() +
                                      voteCount[2]!.toDouble() +
                                      voteCount[3]!.toDouble() +
                                      voteCount[4]!.toDouble())
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
                                (voteCount[1]! + voteCount[2]!).toString() +
                                    "人勝ち予想",
                                textAlign: TextAlign.left)),
                        Container(
                            margin: EdgeInsets.only(right: 14),
                            child: Text(
                                (voteCount[3]! + voteCount[4]!).toString() +
                                    "人勝ち予想",
                                textAlign: TextAlign.right))
                      ],
                    ),
                    Visibility(
                        visible: widget.isDetail && !isSentWrongInfo,
                        child: SizedBox(
                            width: 187,
                            height: 38,
                            child: (TextButton(
                              child: const Text('投票する',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                primary: HexColor('000000'),
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () async {
                                // 投票画面から戻ったら再度試合情報を読み込む
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BoutVoteScreen(widget.boutId),
                                    ));
                                fetchBoutData();
                              },
                            )))),
                    Container(
                        margin: EdgeInsets.fromLTRB(4, 8, 4, 24),
                        child: Column(children: [
                          Text("あなたの予想：${myVoteText}",
                              style: TextStyle(color: Color(0xffdadada)))
                        ])),
                  ]),
                ),
              ),
              Visibility(
                  visible: !widget.isDetail,
                  child: Container(
                      padding: EdgeInsets.all(8),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("結果："),
                            Text(resultText,
                                style: TextStyle(color: HexColor('ff0000'))),
                          ]))),
              Visibility(
                visible: isSentWrongInfo,
                child: ElevatedButton(
                  child: const Text('誤り報告を取り消す'),
                  style: ElevatedButton.styleFrom(
                    primary: HexColor('999999'),
                    onPrimary: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return AlertDialog(
                          title: Text("誤り報告を取り消す"),
                          content: Text("試合情報の誤り報告済みなので投票できません。誤り報告を取り消しますか？"),
                          actions: [
                            ElevatedButton(
                              child: Text("取り消さない"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            ElevatedButton(
                              child: Text("取り消す"),
                              onPressed: () => {
                                fetchBoutData(),
                                FirebaseFirestore.instance
                                    .collection("bouts")
                                    .doc(widget.boutId)
                                    .update({
                                  "wrong_info_count": wrongInfoCount - 1
                                }).then((_) {
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .update({
                                    "votes.${widget.boutId}": 0
                                  }).then((_) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
                                })
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                  margin: EdgeInsets.all(20),
                  child: Column(children: [
                    Text("みんなの勝敗予想"),
                    Text("${fighter1}のKO/TKO/一本勝ち：${voteCount[1]}"),
                    Text("${fighter1}の判定勝ち：${voteCount[2]}"),
                    Text("${fighter2}のKO/TKO/一本勝ち：${voteCount[3]}"),
                    Text("${fighter2}の判定勝ち：${voteCount[4]}"),
                  ])),
              Visibility(
                visible: widget.isDetail && !isSentWrongInfo,
                child: ElevatedButton(
                  child: const Text('試合情報が間違っている'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red[300],
                    onPrimary: Colors.white,
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return AlertDialog(
                          title: Text("試合情報の誤り報告"),
                          content: Text(
                              "この試合情報に誤った情報が含まれますか？（報告が一定数を超えると試合情報が削除されます）"),
                          actions: [
                            ElevatedButton(
                              child: Text("正しい"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            ElevatedButton(
                                child: Text("間違っている"),
                                onPressed: () {
                                  fetchBoutData();
                                  // 投票済みなら投票情報削除
                                  if (myVote != 0) {
                                    FirebaseFirestore.instance
                                        .collection("bouts")
                                        .doc(widget.boutId)
                                        .update({
                                      "vote${myVote}": voteCount[myVote]! - 1,
                                      "wrong_info_count": wrongInfoCount + 1
                                    }).then((_) {
                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .update({
                                        "votes.${widget.boutId}": -1,
                                      }).then((_) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      });
                                    });
                                  } else {
                                    FirebaseFirestore.instance
                                        .collection("bouts")
                                        .doc(widget.boutId)
                                        .update({
                                      "wrong_info_count": wrongInfoCount + 1
                                    }).then((_) {
                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .update({
                                        "votes.${widget.boutId}": -1,
                                      }).then((_) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      });
                                    });
                                  }
                                }),
                          ],
                        );
                      },
                    );
                  },
                ),
              )
            ])
          ],
        ),
      ),
    );
  }

  // 試合情報取得処理
  void fetchBoutData() {
    FirebaseFirestore.instance
        .collection('bouts')
        .doc(widget.boutId)
        .get()
        .then((ref) {
      getMyVote();
      setState(() {
        fighter1 = ref.get("fighter1");
        fighter2 = ref.get("fighter2");
        if (ref['result'] == 0) {
          resultText = "結果集計中";
        } else if (ref['result'] == 1) {
          resultText = '${fighter1}のKO/TKO/一本勝ち';
        } else if (ref['result'] == 2) {
          resultText = '${fighter1}の判定勝ち';
        } else if (ref['result'] == 3) {
          resultText = '${fighter2}のKO/TKO/一本勝ち';
        } else if (ref['result'] == 4) {
          resultText = '${fighter2}の判定勝ち';
        } else if (ref['result'] == 99) {
          resultText = '引き分けまたは無効試合';
        }
        voteCount[1] = ref.get("vote1");
        voteCount[2] = ref.get("vote2");
        voteCount[3] = ref.get("vote3");
        voteCount[4] = ref.get("vote4");
        boutName = ref.get("event_name");
        fightDateText = Functions.dateToString(ref.get("fight_date").toDate());
        wrongInfoCount = ref.get("wrong_info_count");
      });
    });
  }

  // 自分の勝敗予想を取得する処理
  void getMyVote() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((ref) {
      setState(() {
        switch (ref.get("votes")[widget.boutId]) {
          case 1:
            myVote = 1;
            myVoteText = "${fighter1}のKO/TKO/一本勝ち";
            break;
          case 2:
            myVote = 2;
            myVoteText = "${fighter1}の判定勝ち";
            break;
          case 3:
            myVote = 3;
            myVoteText = "${fighter2}のKO/TKO/一本勝ち";
            break;
          case 4:
            myVote = 4;
            myVoteText = "${fighter2}の判定勝ち";
            break;
          case -1:
            myVote = -1;
            myVoteText = "試合情報の誤り報告済み";
            isSentWrongInfo = true;
            break;
          default:
            myVoteText = "勝敗予想していません";
            break;
        }
      });
    });
  }
}
