import 'package:boxing_vote/screens/bout_vote_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Functions.dart';
import '../screens/chat_screen.dart';

class BoutDetail extends StatefulWidget {
  BoutDetail(this.id);
  String id;
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
  int vote1_1 = 0;
  // 選手1の判定勝利予想数
  int vote1_2 = 0;
  // 選手2のKO勝利予想数
  int vote2_1 = 0;
  // 選手2の判定勝利予想数
  int vote2_2 = 0;
  // 自分の予想（0：未投票、1：選手1のKO勝ち、2：選手1の判定勝ち、3：選手2のKO勝ち、4：選手2の判定勝ち）
  String myVoteText = "";

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
                    child: Text('${vote1_1 + vote1_2}人勝ち予想')),
                Container(
                    width: 180,
                    color: Colors.indigo[200],
                    child: Text('${vote2_1 + vote2_2}人勝ち予想'))
              ]),
              Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                      children: [Text("あなたの予想"), Text("${myVoteText}")])),
              ElevatedButton(
                child: const Text('投票する'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                ),
                onPressed: () async {
                  // 投票画面から戻ったら再度試合情報を読み込む
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BoutVoteScreen(widget.id),
                      ));
                  fetchBoutData();
                },
              ),
              Container(
                  margin: EdgeInsets.all(20),
                  child: Column(children: [
                    Text("みんなの勝敗予想"),
                    Text("${fighter1}のKO勝ち：${vote1_1}"),
                    Text("${fighter1}の判定勝ち：${vote1_2}"),
                    Text("${fighter2}のKO勝ち：${vote2_1}"),
                    Text("${fighter2}の判定勝ち：${vote2_2}"),
                  ])),
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
        .doc(widget.id)
        .get()
        .then((ref) {
      getMyVote();
      setState(() {
        fighter1 = ref.get("fighter1");
        fighter2 = ref.get("fighter2");
      });
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
        fightDate = ref.get("fight_date");
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
          default:
            myVoteText = "勝敗予想していません";
            break;
        }
      });
    });
  }
}
