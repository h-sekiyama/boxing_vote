import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Functions.dart';

class Chat extends StatefulWidget {
  Chat(this.boutName);
  String boutName;
  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<Chat> {
  List<DocumentSnapshot> documentList = [];

  void initState() {
    fetchChatData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text(widget.boutName),
            Column(
              children: documentList.map((document) {
                DateTime time = DateTime.now();
                if (document['time'] is Timestamp) {
                  time = document["time"].toDate();
                }
                return Card(
                  child: Column(children: [
                    ListTile(
                      leading: Image.asset('images/cat.png'),
                      title: Text('${document['user_name']}'),
                      subtitle: Text('${document['text']}'),
                      trailing: Text(Functions.dateToStringTime(time)),
                    ),
                  ]),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void fetchChatData() async {
    // 指定コレクションのドキュメント一覧を取得
    final snapshot = await FirebaseFirestore.instance
        .collection('chats')
        .orderBy('time', descending: true)
        .get();
    // ドキュメント一覧を配列で格納
    setState(() {
      documentList = snapshot.docs;
    });
  }
}
