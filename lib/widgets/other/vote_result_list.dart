import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VoteResultList extends StatefulWidget {
  VoteResultList(this.own);
  bool own;
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
                  subtitle: Text('神の予想師')),
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
              })
            });
  }
}
