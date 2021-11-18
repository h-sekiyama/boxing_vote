import 'package:boxing_vote/screens/vote_result_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  // FireStoreのインスタンス
  FirebaseStorage storage = FirebaseStorage.instance;
  // ユーザーアイコンマップ
  Map<String, String> userImagreMap = {};
  // 自分のユーザーID
  var ownId = FirebaseAuth.instance.currentUser!.uid;
  // コメント入力ボックス
  final TextEditingController commentController =
      TextEditingController(text: '');
  // 予想内容
  String voteDetail = "";
  // 送信ボタンを押せるか否か
  bool isEnabledSendButton = false;

  void initState() {
    fetchBoutData();
  }

  // アイコン画像のダウンロード
  Future<String> downloadImage(String userId) async {
    try {
      var imageUrl;
      Reference imageRef =
          storage.ref().child("profile").child("${userId}.png");
      imageUrl = await imageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      return Future<String>.value("no image");
    }
  }

  // 予想内容ダウンロード
  Future<String> getVotedDetail(String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((ref) {
      switch (ref.get("votes")[widget.boutId]) {
        case 1:
          voteDetail = "予想：${fighter1}のKO/TKO/一本勝ち";
          break;
        case 2:
          voteDetail = "予想：${fighter1}の判定勝ち";
          break;
        case 3:
          voteDetail = "予想：${fighter2}のKO/TKO/一本勝ち";
          break;
        case 4:
          voteDetail = "予想：${fighter2}の判定勝ち";
          break;
        default:
          voteDetail = "";
      }
    });
    return voteDetail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Material(
              elevation: 1.0,
              color: Color(0xffFFF8DC),
              child: Container(
                width: MediaQuery.of(context).size.width * 1,
                margin: EdgeInsets.only(bottom: 6),
                color: Color(0xffFFF8DC),
                child: Column(children: [
                  Text(
                      '${Functions.dateToString(fightDate)}' +
                          ' / ' +
                          '${boutName}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text('${fighter1} VS ${fighter2}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ]),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 8)),
            Expanded(
                child: ListView(
              scrollDirection: Axis.vertical,
              children: chatList.map((document) {
                DateTime time = DateTime.now();
                if (document['time'] is Timestamp) {
                  time = document["time"].toDate();
                }
                return GestureDetector(
                    onTap: Functions.checkLogin()
                        ? () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VoteResultListScreen(document['user_id']),
                                ));
                          }
                        : null,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                              visible: document['user_id'] != ownId,
                              child: Container(
                                  width: 48,
                                  height: 48,
                                  margin: EdgeInsets.only(
                                      top: 4, left: 6, right: 4),
                                  child: FutureBuilder(
                                    future: downloadImage(document['user_id']),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data != "no image") {
                                          return Image.network(snapshot.data!);
                                        } else {
                                          return Image.asset('images/cat.png');
                                        }
                                      } else {
                                        return Image.asset('images/cat.png');
                                      }
                                    },
                                  ))),

                          // 吹き出し
                          Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: Column(children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Color(0xffffffff),
                                  child: Column(children: [
                                    ListTile(
                                      // leading: document['user_id'] != ownId
                                      title: Text('${document['user_name']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14)),
                                      subtitle: Text('${document['text']}',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black)),
                                    ),
                                    FutureBuilder(
                                      future:
                                          getVotedDetail(document['user_id']),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String> snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            snapshot.data!,
                                            style: TextStyle(
                                                color: Color(0xffFF7A00),
                                                fontSize: 10),
                                          );
                                        } else {
                                          return Text("");
                                        }
                                      },
                                    ),
                                  ]),
                                ),
                                // 日付
                                Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                                    child: (Text(
                                        Functions.dateToStringTime(time),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey)))),
                              ])),
                          Visibility(
                              visible: document['user_id'] == ownId,
                              child: Container(
                                  width: 48,
                                  height: 48,
                                  margin: EdgeInsets.only(top: 4, left: 6),
                                  child: FutureBuilder(
                                    future: downloadImage(document['user_id']),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> snapshot) {
                                      if (snapshot.hasData) {
                                        if (snapshot.data != "no image") {
                                          return Image.network(snapshot.data!);
                                        } else {
                                          return Image.asset('images/cat.png');
                                        }
                                      } else {
                                        return Image.asset('images/cat.png');
                                      }
                                    },
                                  ))),
                        ]));
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
            Visibility(
                visible: Functions.checkLogin(),
                child: Container(
                    height: 120,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex: 5,
                            child: TextFormField(
                              controller: commentController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              cursorColor: Colors.black,
                              autofocus: false,
                              style: new TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                              decoration: new InputDecoration(
                                filled: true,
                                fillColor: const Color(0xffffffff),
                                hintText: 'コメントを書き込む',
                                hintStyle: TextStyle(color: Color(0xffcccccc)),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff000000),
                                    width: 2,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff000000),
                                    width: 2,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                              onChanged: (value) {
                                chatText = value;
                                if (value.length == 0) {
                                  setState(() {
                                    isEnabledSendButton = false;
                                  });
                                } else {
                                  setState(() {
                                    isEnabledSendButton = true;
                                  });
                                }
                              },
                            )),
                        Padding(padding: EdgeInsets.only(right: 8)),
                        Expanded(
                            flex: 1,
                            child: TextButton(
                              child: const Text('送信',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: isEnabledSendButton
                                  ? () {
                                      FirebaseFirestore.instance
                                          .collection("chats")
                                          .doc()
                                          .set(({
                                            "text": chatText,
                                            "user_id": FirebaseAuth
                                                .instance.currentUser!.uid,
                                            "bout_id": widget.boutId,
                                            "user_name": FirebaseAuth.instance
                                                .currentUser!.displayName,
                                            "time": Timestamp.fromDate(
                                                DateTime.now())
                                          }))
                                          .then((value) => {
                                                chatText = "",
                                                FocusScope.of(context)
                                                    .unfocus(),
                                                fetchChatData(),
                                                commentController.clear(),
                                                setState(() {
                                                  isEnabledSendButton = false;
                                                })
                                              });
                                    }
                                  : null,
                            )),
                      ],
                    )))
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
        fightDate = ref.get("fight_date").toDate();
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
