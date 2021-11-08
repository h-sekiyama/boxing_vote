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
  // 試合日程
  DateTime fightDate = DateTime.now();
  // 選手1のKO勝利予想数
  int vote1 = 0;
  // 選手1の判定勝利予想数
  int vote2 = 0;
  // 選手2のKO勝利予想数
  int vote3 = 0;
  // 選手2の判定勝利予想数
  int vote4 = 0;
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
              Column(children: [
                Text('${Functions.dateToString(fightDate)}'),
                Text('${boutName}'),
                Text('${fighter1} VS ${fighter2}'),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Container(
                    width: 180,
                    color: Colors.red[100],
                    child: Text('${vote1 + vote2}人勝ち予想')),
                Container(
                    width: 180,
                    color: Colors.indigo[200],
                    child: Text('${vote3 + vote4}人勝ち予想'))
              ]),
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
              Container(
                  margin: EdgeInsets.all(8),
                  child: Column(
                      children: [Text("あなたの予想"), Text("${myVoteText}")])),
              Visibility(
                visible: widget.isDetail && !isSentWrongInfo,
                child: ElevatedButton(
                  child: const Text('投票する'),
                  style: ElevatedButton.styleFrom(
                    primary: HexColor('ff0099'),
                    onPrimary: Colors.white,
                  ),
                  onPressed: () async {
                    // 投票画面から戻ったら再度試合情報を読み込む
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BoutVoteScreen(widget.boutId),
                        ));
                    fetchBoutData();
                  },
                ),
              ),
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
                                    "votes.${widget.boutId}": 0,
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
                    Text("${fighter1}のKO/TKO/一本勝ち：${vote1}"),
                    Text("${fighter1}の判定勝ち：${vote2}"),
                    Text("${fighter2}のKO/TKO/一本勝ち：${vote3}"),
                    Text("${fighter2}の判定勝ち：${vote4}"),
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
                              onPressed: () => {
                                fetchBoutData(),
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
                                })
                              },
                            ),
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
      });
      setState(() {
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
      });
      setState(() {
        vote1 = ref.get("vote1");
        vote2 = ref.get("vote2");
        vote3 = ref.get("vote3");
        vote4 = ref.get("vote4");
      });
      setState(() {
        boutName = ref.get("event_name");
      });
      setState(() {
        fightDate = ref.get("fight_date");
      });
      setState(() {
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
            myVoteText = "${fighter1}のKO/TKO/一本勝ち";
            break;
          case 2:
            myVoteText = "${fighter1}の判定勝ち";
            break;
          case 3:
            myVoteText = "${fighter2}のKO/TKO/一本勝ち";
            break;
          case 4:
            myVoteText = "${fighter2}の判定勝ち";
            break;
          case -1:
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
