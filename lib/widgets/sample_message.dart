import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SampleMessage extends StatefulWidget {
  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<SampleMessage> {
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
                return ListTile(
                  title: Text('興行名:${document['event_name']}'),
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
