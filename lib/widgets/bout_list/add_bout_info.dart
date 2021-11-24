import 'package:boxing_vote/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../common/Functions.dart';

class AddBoutInfo extends StatefulWidget {
  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<AddBoutInfo> {
  // 種目リスト
  List<DropdownMenuItem<String>> _items = [];
  String _sportsName = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setItems();
    _sportsName = _items[0].value!;
  }

  void setItems() {
    _items
      ..add(DropdownMenuItem(
        child: Text(
          'ボクシング',
          style: TextStyle(fontSize: 20.0),
        ),
        value: "ボクシング",
      ))
      ..add(DropdownMenuItem(
        child: Text(
          'K-1',
          style: TextStyle(fontSize: 20.0),
        ),
        value: "K-1",
      ))
      ..add(DropdownMenuItem(
        child: Text(
          'RIZIN',
          style: TextStyle(fontSize: 20.0),
        ),
        value: "RIZIN",
      ));
  }

  // 試合日
  String _eventDate = "試合日";
  DateTime _selectedDate = DateTime.now();
  // 試合詳細
  String _eventName = "";
  // 選手1氏名
  String _fighter1 = "";
  // 選手2氏名
  String _fighter2 = "";

  Future<void> addBoutInfo() async {
    // 登録結果を格納する
    // バリデーションを実行
    final isValid = _formKey.currentState!.validate();
    // キーボードを閉じる
    FocusScope.of(context).unfocus();

    // バリデーションに問題がなければ登録
    if (isValid) {
      // formの内容を保存
      _formKey.currentState!.save();

      // 試合情報追加を実行
      showConfirmDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(left: 8, top: 8, right: 8),
                child: Text(
                  "試合情報は全ユーザーに公開されます。公序良俗に反する文章などを入力するとアカウントを凍結させて頂く場合がございますので、ご注意下さい。",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                )),
            Container(
                margin: EdgeInsets.only(left: 8, bottom: 8, right: 8),
                child: Text(
                  "皆さんが勝敗予想を楽しめる様、正しい試合情報を投稿して頂けます様にお願い致します。",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            // 種目選択
            Container(
                margin: EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 8),
                padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                child: DropdownButtonFormField(
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    decoration: new InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      filled: true,
                      fillColor: const Color(0xffffffff),
                      hintText: '種目',
                      hintStyle: TextStyle(color: Color(0xffcccccc)),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff000000),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff000000),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    items: _items,
                    value: _sportsName,
                    onChanged: (value) => {
                          setState(() {
                            _sportsName = value.toString();
                          })
                        })),
            //試合日選択
            Container(
                margin: EdgeInsets.only(top: 0, bottom: 10, left: 8, right: 8),
                padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                child: TextFormField(
                    autofocus: false,
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    decoration: new InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      filled: true,
                      fillColor: const Color(0xffffffff),
                      hintText: "${_eventDate}",
                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff000000),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff000000),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    validator: (value) {
                      if (_eventDate == "試合日") {
                        return '試合日は必須項目です';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _eventDate = value;
                    },
                    onTap: () async {
                      _selectedDate = (await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(Duration(days: 1)),
                            firstDate: DateTime.now().add(Duration(days: 1)),
                            lastDate: DateTime(DateTime.now().year + 1),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: Color(0xffE6D200), // ヘッダー背景色
                                    onPrimary: Colors.black, // ヘッダーテキストカラー
                                    onSurface: Colors.green, // カレンダーのテキストカラー
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      primary: Colors.black, // ボタンのテキストカラー
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          )) ??
                          DateTime.now();
                      setState(() {
                        _eventDate = Functions.dateToString(_selectedDate);
                      });
                      FocusManager.instance.primaryFocus!.unfocus();
                    })),
            // 試合詳細入力
            Container(
                margin: EdgeInsets.only(top: 0, bottom: 10, left: 8, right: 8),
                padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                child: Column(children: [
                  Container(
                      width: double.infinity,
                      child: Text(
                        "例：WBA世界ライト級タイトルマッチ",
                        textAlign: TextAlign.left,
                      )),
                  TextFormField(
                    autofocus: false,
                    cursorColor: Colors.black,
                    maxLength: 40,
                    style: new TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    decoration: new InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                      filled: true,
                      fillColor: const Color(0xffffffff),
                      hintText: "試合詳細",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff000000),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff000000),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    validator: (value) {
                      if (value!.length == 0) {
                        return '試合詳細は必須項目です';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _eventName = value;
                    },
                  )
                ])),
            // 選手1氏名入力
            Container(
                margin: EdgeInsets.only(top: 0, bottom: 10, left: 8, right: 8),
                padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                child: TextFormField(
                  autofocus: false,
                  maxLength: 20,
                  cursorColor: Colors.black,
                  style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  decoration: new InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    filled: true,
                    fillColor: const Color(0xffffffff),
                    hintText: "選手1氏名",
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff000000),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff000000),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  validator: (value) {
                    if (value!.length == 0) {
                      return '選手1氏名は必須項目です';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _fighter1 = value;
                  },
                )),
            // 選手2氏名入力
            Container(
                margin: EdgeInsets.only(top: 0, bottom: 10, left: 8, right: 8),
                padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                child: TextFormField(
                  maxLength: 20,
                  autofocus: false,
                  cursorColor: Colors.black,
                  style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  decoration: new InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    filled: true,
                    fillColor: const Color(0xffffffff),
                    hintText: "選手2氏名",
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff000000),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff000000),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  validator: (value) {
                    if (value!.length == 0) {
                      return '選手2氏名は必須項目です';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _fighter2 = value;
                  },
                )),
            // 試合追加ボタン
            Container(
                width: 180,
                child: ElevatedButton(
                  child: Text("追加する",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                  onPressed: () {
                    addBoutInfo();
                  },
                )),
          ],
        ),
      )),
    );
  }

  // 確認ダイアログ表示
  void showConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("試合情報追加"),
          content: Text("以下の試合情報を追加して宜しいですか？" +
              "\n\n種目：${_sportsName}\n試合日：${_eventDate}\n試合詳細：${_eventName}\n${_fighter1} VS ${_fighter2}"),
          actions: [
            ElevatedButton(
              child: Text("やめる"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text("確定"),
              onPressed: () => {
                FirebaseFirestore.instance
                    .collection("bouts")
                    .doc()
                    .set(({
                      "event_name": _eventName,
                      "sports": _sportsName,
                      "fight_date": Timestamp.fromDate(_selectedDate),
                      "fighter1": _fighter1,
                      "fighter2": _fighter2,
                      "fix": 0,
                      "result": 0,
                      "vote1": 0,
                      "vote2": 0,
                      "vote3": 0,
                      "vote4": 0,
                      "sentResult1": 0,
                      "sentResult2": 0,
                      "sentResult3": 0,
                      "sentResult4": 0,
                      "sentResult99": 0,
                      "wrong_info_count": 0,
                      "addUserId": FirebaseAuth.instance.currentUser!.uid
                    }))
                    .then((value) => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen(true, "全て")))
                        })
              },
            ),
          ],
        );
      },
    );
  }
}
