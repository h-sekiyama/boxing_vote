import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Functions.dart';
import '../screens/chat_screen.dart';

class BoutsList extends StatefulWidget {
  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<BoutsList> {
  // ドキュメント情報を入れる箱を用意
  List<DocumentSnapshot> documentList = [];

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
            Column(
              children: documentList.map((document) {
                DateTime fight_date = DateTime.now();
                if (document['fight_date'] is Timestamp) {
                  fight_date = document["fight_date"].toDate();
                }
                return Card(
                  child: Column(children: [
                    ListTile(
                      leading: Image.asset('images/cat.png'),
                      title: Text(
                          '${document['fighter1']} VS ${document['fighter2']}'),
                      subtitle: Text('${document['event_name']}'),
                      trailing: Text(Functions.dateToString(fight_date)),
                    ),
                    ListTile(
                      title: Text(
                          '${document['fighter1']}の勝ち予想：${document['vote1_1'] + document['vote1_2']}人\n${document['fighter2']}の勝ち予想：${document['vote2_1'] + document['vote2_2']}人'),
                    )
                  ]),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void fetchBoutData() async {
    // 指定コレクションのドキュメント一覧を取得
    final snapshot = await FirebaseFirestore.instance.collection('bouts').get();
    // ドキュメント一覧を配列で格納
    setState(() {
      documentList = snapshot.docs;
    });
  }
}
