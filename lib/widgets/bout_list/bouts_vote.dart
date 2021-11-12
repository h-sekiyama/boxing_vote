import 'package:boxing_vote/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../common/Functions.dart';

class BoutVote extends StatefulWidget {
  BoutVote(this.id);
  String id;
  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<BoutVote> {
  // 興行名
  String boutName = "";
  // 選手1
  String fighter1 = "";
  // 選手2
  String fighter2 = "";
  // 試合日程
  DateTime fightDate = DateTime.now();
  // 試合日程テキスト
  String fightDateText = "";
  // 予想数Map（1：選手1のKO勝ち、2：選手1の判定勝ち、3：選手2のKO勝ち、4：選手2の判定勝ち）
  Map<int, int> voteCount = {1: 0, 2: 0, 3: 0, 4: 0};
  // 自分の予想（0：未投票、1：選手1のKO勝ち、2：選手1の判定勝ち、3：選手2のKO勝ち、4：選手2の判定勝ち）
  int myVote = 0;
  // 今回の予想
  int nowVote = 0;
  // 自分の予想結果テキスト
  String myVoteText = "";

  void initState() {
    fetchBoutData();
    getMyVote();
  }

  @override
  Widget build(BuildContext context) {
    // 勝敗予想投票処理
    void voteBoutResult(int voteResult, String boutId) {
      fetchBoutData();

      // 改めて投票受付期間かを確認
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
                    (serverTimeSnapshot['serverTimeStamp'] as Timestamp)
                        .toDate(),
                if (fightDate.isAfter(serverTime))
                  {
                    // 自分の投票履歴を更新
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .update({
                      "votes.${boutId}": voteResult,
                    }).then((_) {
                      // 投票数を更新
                      FirebaseFirestore.instance
                          .collection("bouts")
                          .doc(boutId)
                          .update({
                        "vote${nowVote}": voteCount[nowVote]! + 1,
                        "vote${myVote}": myVote != 0
                            ? voteCount[myVote]! - 1
                            : voteCount[myVote]
                      }).then((value) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    })
                  }
                else
                  {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return AlertDialog(
                          title: Text("投票受付終了"),
                          content: Text("投票できる期間は試合日の前日までとなります。"),
                          actions: [
                            ElevatedButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomeScreen(true, "全て"),
                                        fullscreenDialog: true));
                              },
                            ),
                          ],
                        );
                      },
                    )
                  }
              });
    }

    // 確認ダイアログ表示
    void showConfirmDialog(int voteResult, String boutId) {
      String dialogText = "";
      switch (voteResult) {
        case 1:
          dialogText = "${fighter1}のKO勝ちで宜しいですか？";
          break;
        case 2:
          dialogText = "${fighter1}の判定勝ちで宜しいですか？";
          break;
        case 3:
          dialogText = "${fighter2}のKO勝ちで宜しいですか？";
          break;
        case 4:
          dialogText = "${fighter2}の判定勝ちで宜しいですか？";
          break;
      }
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: Text("勝敗予想"),
            content: Text(dialogText + "\n" + "予想内容は試合前日までは変更できます"),
            actions: [
              ElevatedButton(
                child: Text("やめる"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: Text("投票する"),
                onPressed: () => {voteBoutResult(voteResult, boutId)},
              ),
            ],
          );
        },
      );
    }

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
              Container(
                  margin: EdgeInsets.all(20),
                  child: Column(children: [Text("予想を投票する")])),
              ElevatedButton(
                child: Text("${fighter1}のKO/TKO/一本勝ち"),
                style: ElevatedButton.styleFrom(
                  primary: myVote == 1 ? Colors.orange : Colors.grey,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  nowVote = 1;
                  showConfirmDialog(nowVote, widget.id);
                },
              ),
              ElevatedButton(
                child: Text("${fighter1}の判定勝ち"),
                style: ElevatedButton.styleFrom(
                  primary: myVote == 2 ? Colors.orange : Colors.grey,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  nowVote = 2;
                  showConfirmDialog(nowVote, widget.id);
                },
              ),
              ElevatedButton(
                child: Text("${fighter2}のKO/TKO/一本勝ち"),
                style: ElevatedButton.styleFrom(
                  primary: myVote == 3 ? Colors.orange : Colors.grey,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  nowVote = 3;
                  showConfirmDialog(nowVote, widget.id);
                },
              ),
              ElevatedButton(
                child: Text("${fighter2}の判定勝ち"),
                style: ElevatedButton.styleFrom(
                  primary: myVote == 4 ? Colors.orange : Colors.grey,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  nowVote = 4;
                  showConfirmDialog(nowVote, widget.id);
                },
              ),
            ])
          ],
        ),
      ),
    );
  }

  // 試合情報取得
  void fetchBoutData() {
    FirebaseFirestore.instance
        .collection('bouts')
        .doc(widget.id)
        .get()
        .then((ref) {
      setState(() {
        fightDate = ref.get("fight_date").toDate();
        voteCount[1] = ref.get("vote1");
        voteCount[2] = ref.get("vote2");
        voteCount[3] = ref.get("vote3");
        voteCount[4] = ref.get("vote4");
        boutName = ref.get("event_name");
        fighter1 = ref.get("fighter1");
        fighter2 = ref.get("fighter2");
        switch (ref.get("my_vote")) {
          case 1:
            myVoteText = "${fighter1}のKO勝ち";
            break;
          case 2:
            myVoteText = "${fighter1}の判定勝ち";
            break;
          case 3:
            myVoteText = "${fighter2}のKO勝ち";
            break;
          case 4:
            myVoteText = "${fighter2}の判定勝ち";
            break;
        }
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
        switch (ref.get("votes")[widget.id]) {
          case 1:
            myVote = 1;
            break;
          case 2:
            myVote = 2;
            break;
          case 3:
            myVote = 3;
            break;
          case 4:
            myVote = 4;
            break;
          default:
            myVote = 0;
            break;
        }
      });
    });
  }
}
