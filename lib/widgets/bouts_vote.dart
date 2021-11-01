import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Functions.dart';
import '../screens/chat_screen.dart';

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
  // 選手1のKO勝利予想数
  int vote1_1 = 0;
  // 選手1の判定勝利予想数
  int vote1_2 = 0;
  // 選手2のKO勝利予想数
  int vote2_1 = 0;
  // 選手2の判定勝利予想数
  int vote2_2 = 0;
  // 自分の予想（0：未投票、1：選手1のKO勝ち、2：選手1の判定勝ち、3：選手2のKO勝ち、4：選手2の判定勝ち）
  String myVote = "";

  void initState() {
    fetchBoutData();
  }

  @override
  Widget build(BuildContext context) {
    // 勝敗予想投票処理
    void voteBoutForecast(int voteResult, String boutId) {
      FirebaseFirestore.instance
          .collection("users")
          .doc("bmfVCGaDsRah7bcqIa5D")
          .update({
        "votes.${boutId}": voteResult,
      }).then((_) {
        Navigator.pop(context);
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
              FlatButton(
                child: Text("やめる"),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text("投票する"),
                onPressed: () => voteBoutForecast(voteResult, boutId),
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
                  primary: Colors.grey,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  showConfirmDialog(1, widget.id);
                },
              ),
              ElevatedButton(
                child: Text("${fighter1}の判定勝ち"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  showConfirmDialog(2, widget.id);
                },
              ),
              ElevatedButton(
                child: Text("${fighter2}のKO/TKO/一本勝ち"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  showConfirmDialog(3, widget.id);
                },
              ),
              ElevatedButton(
                child: Text("${fighter2}の判定勝ち"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  showConfirmDialog(4, widget.id);
                },
              ),
            ])
          ],
        ),
      ),
    );
  }

  void fetchBoutData() {
    FirebaseFirestore.instance
        .collection('bouts')
        .doc(widget.id)
        .get()
        .then((ref) {
      setState(() {
        vote1_1 = ref.get("vote1_1");
        vote1_2 = ref.get("vote1_2");
        vote2_1 = ref.get("vote2_1");
        vote2_2 = ref.get("vote2_2");
      });
      setState(() {
        boutName = ref.get("event_name");
      });
      setState(() {
        fighter1 = ref.get("fighter1");
        fighter2 = ref.get("fighter2");
        switch (ref.get("my_vote")) {
          case 1:
            myVote = "${fighter1}のKO勝ち";
            break;
          case 2:
            myVote = "${fighter1}の判定勝ち";
            break;
          case 3:
            myVote = "${fighter2}のKO勝ち";
            break;
          case 4:
            myVote = "${fighter2}の判定勝ち";
            break;
        }
      });
      setState(() {
        fightDate = ref.get("fight_date");
      });
    });
  }
}
