import 'package:boxing_vote/common/HexColor.dart';
import 'package:boxing_vote/screens/bout_detail_screen.dart';
import 'package:boxing_vote/screens/send_bout_result_screen.dart';
import 'package:boxing_vote/widgets/bout_list/bouts_detail.dart';
import 'package:boxing_vote/widgets/bout_list/send_bouts_result.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../common/Functions.dart';
import '../../screens/chat_screen.dart';

class BoutsList extends StatefulWidget {
  BoutsList(this.isList);
  bool isList;

  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<BoutsList> {
  // ドキュメント情報を入れる箱を用意
  List<DocumentSnapshot> documentList = [];
  // 結果文言
  String resultText = "";

  void initState() {
    fetchBoutData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            // ドキュメント情報を表示
            Expanded(
                child: ListView(
              scrollDirection: Axis.vertical,
              children: documentList.map((document) {
                DateTime fight_date = DateTime.now();
                if (document['fight_date'] is Timestamp) {
                  fight_date = document["fight_date"].toDate();
                }
                if (document['result'] == 0) {
                  resultText = "結果集計中";
                } else if (document['result'] == 1) {
                  resultText = '${document['fighter1']}のKO/TKO/一本勝ち';
                } else if (document['result'] == 2) {
                  resultText = '${document['fighter1']}の判定勝ち';
                } else if (document['result'] == 3) {
                  resultText = '${document['fighter2']}のKO/TKO/一本勝ち';
                } else if (document['result'] == 4) {
                  resultText = '${document['fighter2']}の判定勝ち';
                }
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  // 試合結果画面からの遷移でかつ試合結果がまだ集計中の場合は投票画面に遷移、それ以外は試合詳細画面に遷移
                                  !widget.isList && document['result'] == 0
                                      ? SendBoutResultScreen(document.id)
                                      : BoutDetailScreen(
                                          document.id, widget.isList)));
                    },
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
                        Visibility(
                            visible: !widget.isList,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("結果："),
                                  Text(resultText,
                                      style:
                                          TextStyle(color: HexColor('ff0000'))),
                                ])),
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

  void fetchBoutData() async {
    // 指定コレクションのドキュメント一覧を取得
    final snapshot = await FirebaseFirestore.instance
        .collection('bouts')
        .orderBy('fight_date', descending: true)
        .get();
    // ドキュメント一覧を配列で格納
    documentList = snapshot.docs;

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
                  (serverTimeSnapshot['serverTimeStamp'] as Timestamp).toDate(),
              if (widget.isList)
                {
                  documentList.removeWhere((document) =>
                      document["fight_date"].toDate().isBefore(serverTime))
                }
              else
                {
                  documentList.removeWhere((document) =>
                      document["fight_date"].toDate().isAfter(serverTime))
                },

              // ドキュメント一覧を配列で格納
              setState(() {
                documentList = documentList;
              })
            });
  }
}
