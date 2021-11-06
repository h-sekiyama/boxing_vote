import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../common/Functions.dart';

class Chat extends StatefulWidget {
  Chat(this.boutId);
  String boutId;
  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<Chat> {
  // チャット情報配列
  List<DocumentSnapshot> chatList = [];
  // 興行名
  String boutName = "";
  // 選手1
  String fighter1 = "";
  // 選手2
  String fighter2 = "";
  // 試合日程
  DateTime fightDate = DateTime.now();
  // チャットがありませんの文字列表示非表示
  bool isNoChatTextVisible = false;
  // チャットテキスト
  String chatText = "";

  void initState() {
    fetchBoutData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Column(children: [
              Text('${Functions.dateToString(fightDate)}'),
              Text('${boutName}'),
              Text('${fighter1} VS ${fighter2}'),
            ]),
            Expanded(
                child: ListView(
              scrollDirection: Axis.vertical,
              children: chatList.map((document) {
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
            )),
            Visibility(
                visible: isNoChatTextVisible,
                child: Center(
                    child: Padding(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "まだ書き込みがありません",
                              style: TextStyle(fontSize: 14.0),
                            )
                          ],
                        ),
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 300)))),
            Container(
                padding: EdgeInsets.fromLTRB(4, 0, 2, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        flex: 6,
                        child: TextFormField(
                          autofocus: false,
                          style: new TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                          decoration: new InputDecoration(
                            hintText: 'コメントを追加',
                          ),
                          onChanged: (value) {
                            chatText = value;
                          },
                        )),
                    Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          child: const Text('送る'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.orange,
                            onPrimary: Colors.white,
                          ),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection("chats")
                                .doc()
                                .set(({
                                  "text": chatText,
                                  "user_id":
                                      FirebaseAuth.instance.currentUser!.uid,
                                  "bout_id": widget.boutId,
                                  "user_name": FirebaseAuth
                                      .instance.currentUser!.displayName,
                                  "time": Timestamp.fromDate(DateTime.now())
                                }))
                                .then((value) => {
                                      chatText = "",
                                      FocusScope.of(context).unfocus(),
                                      fetchChatData()
                                    });
                          },
                        )),
                  ],
                ))
          ],
        ),
      ),
    ));
  }

  // 試合情報取得処理
  void fetchBoutData() {
    FirebaseFirestore.instance
        .collection('bouts')
        .doc(widget.boutId)
        .get()
        .then((ref) {
      fetchChatData();
      setState(() {
        fighter1 = ref.get("fighter1");
        fighter2 = ref.get("fighter2");
      });
      setState(() {
        boutName = ref.get("event_name");
      });
      setState(() {
        fightDate = ref.get("fight_date");
      });
    });
  }

  void fetchChatData() async {
    // 指定コレクションのドキュメント一覧を取得
    final snapshot = await FirebaseFirestore.instance
        .collection('chats')
        .where('bout_id', isEqualTo: widget.boutId)
        .orderBy('time', descending: true)
        .get();
    // ドキュメント一覧を配列で格納
    setState(() {
      isNoChatTextVisible = snapshot.docs.length == 0;
      chatList = snapshot.docs;
    });
  }
}
