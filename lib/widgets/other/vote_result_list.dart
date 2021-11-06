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
                  if (votedBoutsList.containsKey(docs.id) &&
                      docs["result"] == votedBoutsList[docs.id]) {
                    wonBoutCount++;
                  }
                });
              }),
              setState(() {
                totalVoteBoutCount = votedBoutsList.length;
                wonBoutCount = wonBoutCount;
                wonBoutRate = wonBoutCount / totalVoteBoutCount * 100;
                title = getTitle(totalVoteBoutCount, wonBoutCount, wonBoutRate);
              })
            });
  }

  // 称号を割り当てる処理
  String getTitle(totalVoteBoutCount, wonBoutCount, wonBoutRate) {
    if (totalVoteBoutCount == 0) {
      title = "ひよっこ予想師";
    } else if (totalVoteBoutCount == 1 && wonBoutRate == 100) {
      title = "期待のルーキー";
    } else if (totalVoteBoutCount == 1 && wonBoutRate == 0) {
      title = "出だし不調な予想師";
    } else if (totalVoteBoutCount == 2 && wonBoutRate == 50) {
      title = "これからに期待";
    } else if (totalVoteBoutCount == 2 && wonBoutRate == 0) {
      title = "カス予備軍";
    } else if (totalVoteBoutCount == 3 && wonBoutRate == 100) {
      title = "神の予感";
    } else if (totalVoteBoutCount == 3 && wonBoutRate > 66) {
      title = "優秀な予想師・・・かも？";
    } else if (totalVoteBoutCount == 3 &&
        wonBoutRate > 33 &&
        wonBoutRate < 66) {
      title = "平凡な予想師";
    } else if (totalVoteBoutCount == 3 && wonBoutRate == 0) {
      title = "カス予想師一歩手前";
    } else if (totalVoteBoutCount == 4 && wonBoutRate == 100) {
      title = "神予想師予備軍";
    } else if (totalVoteBoutCount == 4 &&
        wonBoutRate >= 25 &&
        wonBoutRate < 50) {
      title = "平凡な予想師";
    } else if (totalVoteBoutCount == 4 &&
        wonBoutRate >= 50 &&
        wonBoutRate < 75) {
      title = "そこそこな予想師";
    } else if (totalVoteBoutCount == 4 && wonBoutRate == 0) {
      title = "カス予想師";
    } else if (totalVoteBoutCount >= 5 && wonBoutRate == 100) {
      title = "神予想師";
    } else if (totalVoteBoutCount >= 5 &&
        wonBoutRate >= 75 &&
        wonBoutRate < 100) {
      title = "すごく優秀な予想師";
    } else if (totalVoteBoutCount >= 5 &&
        wonBoutRate >= 50 &&
        wonBoutRate < 75) {
      title = "なかなか優秀な予想師";
    } else if (totalVoteBoutCount >= 5 &&
        wonBoutRate >= 25 &&
        wonBoutRate < 50) {
      title = "平凡な予想師";
    } else if (totalVoteBoutCount >= 5 && wonBoutRate > 0 && wonBoutRate < 25) {
      title = "イマイチな予想師";
    } else if (totalVoteBoutCount >= 5 && wonBoutRate == 0) {
      title = "ゴミクズ予想師";
    }
    return title;
  }
}
