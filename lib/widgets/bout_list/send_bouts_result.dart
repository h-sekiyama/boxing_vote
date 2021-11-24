import 'package:boxing_vote/common/HexColor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../common/Functions.dart';

class SendBoutResult extends StatefulWidget {
  SendBoutResult(this.id);
  String id;
  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<SendBoutResult> {
  // 興行名
  String boutName = "";
  // 選手1
  String fighter1 = "";
  // 選手2
  String fighter2 = "";
  // 試合日程
  DateTime fightDate = DateTime.now();
  // 結果報告数Map（1：選手1のKO/TKO/一本勝ち、2：選手1の判定勝ち、3：選手2のKO/TKO/一本勝ち、4：選手2の判定勝ち）
  Map<int, int> sentResultCount = {1: 0, 2: 0, 3: 0, 4: 0, 99: 0};
  // 自分の報告内容（0：未報告、1：選手1のKO/TKO/一本勝ち、2：選手1の判定勝ち、3：選手2のKO/TKO/一本勝ち、4：選手2の判定勝ち）
  int mySentResult = 0;
  // 今回の報告
  int nowSendResult = 0;
  // 合計予想数
  int totalVotedCount = 0;
  // 一番報告の多い結果
  int maxSentResult = 0;

  void initState() {
    fetchBoutData();
    getMySentResult();
  }

  @override
  Widget build(BuildContext context) {
    // 勝敗結果報告処理
    void voteBoutForecast(int sentResult, String boutId) {
      fetchBoutData();
      // 報告数を更新
      FirebaseFirestore.instance.collection("bouts").doc(boutId).update(
          {"sentResult${nowSendResult}": sentResultCount[nowSendResult]! + 1});
      if (mySentResult != 0) {
        // 既に報告済みだった場合は前の報告を削除
        FirebaseFirestore.instance.collection("bouts").doc(boutId).update(
            {"sentResult${mySentResult}": sentResultCount[mySentResult]! - 1});
      }

      // 報告数が勝敗予想者数の1割を超えたら or 報告数が一定数を超えたら結果を確定する
      var maxSentResultCount = 0;
      sentResultCount.forEach((key, value) {
        if (maxSentResultCount < value) {
          maxSentResultCount = value;
          maxSentResult = key;
        }
      });
      maxSentResultCount++; // 今回の投票分も加える
      if (maxSentResultCount > 10 ||
          maxSentResultCount > totalVotedCount / 10) {
        // 自分の投票履歴を更新
        FirebaseFirestore.instance
            .collection("bouts")
            .doc(boutId)
            .update({"result": maxSentResult}).then((_) {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      } else {
        // 自分の投票履歴を更新
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "mySentResult.${boutId}": sentResult,
        }).then((_) {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      }
    }

    // 確認ダイアログ表示
    void showConfirmDialog(int sentResult, String boutId) {
      String dialogText = "";
      switch (sentResult) {
        case 1:
          dialogText = "試合結果は${fighter1}のKO/TKO/一本勝ちでしたか？";
          break;
        case 2:
          dialogText = "試合結果は${fighter1}の判定勝ちでしたか？";
          break;
        case 3:
          dialogText = "試合結果は${fighter2}のKO/TKO/一本勝ちでしたか？";
          break;
        case 4:
          dialogText = "試合結果は${fighter2}の判定勝ちでしたか？";
          break;
        case 99:
          dialogText = "試合結果は引き分け、または無効試合でしたか？";
          break;
      }
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: Text("結果報告"),
            content: Text(dialogText),
            actions: [
              Container(
                  width: 400,
                  child: ElevatedButton(
                    child: Text("やめる",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  )),
              Container(
                  width: 400,
                  child: ElevatedButton(
                    child: Text("報告する",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => {voteBoutForecast(sentResult, boutId)},
                  )),
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
              Material(
                elevation: 1.0,
                color: Color(0xffFFF8DC),
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  margin: EdgeInsets.only(bottom: 6),
                  padding: EdgeInsets.only(left: 8, right: 8),
                  color: Color(0xffFFF8DC),
                  child: Column(children: [
                    Text(
                        '${Functions.dateToString(fightDate)}' +
                            ' / ' +
                            '${boutName}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('${fighter1} VS ${fighter2}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                  ]),
                ),
              ),
              Container(
                  margin: EdgeInsets.all(10),
                  child: Text("試合結果集計中です\n宜しければ試合結果を報告して下さい")),
              Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.all(8),
                  child: ElevatedButton(
                    child: Text("${fighter1}のKO/TKO/一本勝ち",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: mySentResult == 0
                        ? () {
                            nowSendResult = 1;
                            showConfirmDialog(nowSendResult, widget.id);
                          }
                        : null,
                  )),
              Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.all(8),
                  child: ElevatedButton(
                    child: Text("${fighter1}の判定勝ち",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: mySentResult == 0
                        ? () {
                            nowSendResult = 2;
                            showConfirmDialog(nowSendResult, widget.id);
                          }
                        : null,
                  )),
              Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.all(8),
                  child: ElevatedButton(
                    child: Text("${fighter2}のKO/TKO/一本勝ち",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: mySentResult == 0
                        ? () {
                            nowSendResult = 3;
                            showConfirmDialog(nowSendResult, widget.id);
                          }
                        : null,
                  )),
              Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.all(8),
                  child: ElevatedButton(
                    child: Text("${fighter2}の判定勝ち",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: mySentResult == 0
                        ? () {
                            nowSendResult = 4;
                            showConfirmDialog(nowSendResult, widget.id);
                          }
                        : null,
                  )),
              Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.all(8),
                  child: ElevatedButton(
                    child: Text("引き分け/無効試合/反則",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: mySentResult == 0
                        ? () {
                            nowSendResult = 99;
                            showConfirmDialog(nowSendResult, widget.id);
                          }
                        : null,
                  )),
              Container(
                  margin: EdgeInsets.all(14),
                  child: Center(
                      child: Text(
                          "結果報告が一定数を超えると結果が確定します。\n皆様が楽しくアプリをご利用頂く為に正しい試合結果をご報告頂けますようお願い致します。",
                          style: TextStyle(
                              fontSize: 14.0, color: HexColor('#999999')))))
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
      setState(() {
        boutName = ref.get("event_name");
        fighter1 = ref.get("fighter1");
        fighter2 = ref.get("fighter2");
        fightDate = ref.get("fight_date").toDate();
        totalVotedCount = ref.get("vote1") +
            ref.get("vote2") +
            ref.get("vote3") +
            ref.get("vote4");
      });
      sentResultCount[1] = ref.get("sentResult1");
      sentResultCount[2] = ref.get("sentResult2");
      sentResultCount[3] = ref.get("sentResult3");
      sentResultCount[4] = ref.get("sentResult4");
      sentResultCount[99] = ref.get("sentResult99");
    });
  }

  // 自分の報告結果を取得する処理
  void getMySentResult() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((ref) {
      setState(() {
        switch (ref.get("mySentResult")[widget.id]) {
          case 1:
            mySentResult = 1;
            break;
          case 2:
            mySentResult = 2;
            break;
          case 3:
            mySentResult = 3;
            break;
          case 4:
            mySentResult = 4;
            break;
          case 99:
            mySentResult = 99;
            break;
          default:
            mySentResult = 0;
            break;
        }
      });
    });
  }
}
