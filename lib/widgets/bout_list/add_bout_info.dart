import 'package:boxing_vote/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  // 大会名
  String _eventName = "";
  // 選手1氏名
  String _fighter1 = "";
  // 選手2氏名
  String _fighter2 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.all(8),
                child: Text(
                  "試合予定を追加する事ができます。\n皆さんが勝敗予想を楽しめる様、正しい試合情報を投稿して頂けます様にお願い致します。",
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
                margin: EdgeInsets.only(top: 00, bottom: 10, left: 8, right: 8),
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
                    onChanged: (value) {
                      _eventDate = value.toString();
                      setState(() {
                        _sportsName = value.toString();
                      });
                    },
                    onTap: () async {
                      _selectedDate = (await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year),
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
            // 大会名入力
            Container(
                margin: EdgeInsets.only(top: 00, bottom: 10, left: 8, right: 8),
                padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                child: TextFormField(
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
                    hintText: "大会名",
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
                  onChanged: (value) {
                    _eventName = value;
                  },
                )),
            // 選手1氏名入力
            Container(
                margin: EdgeInsets.only(top: 00, bottom: 10, left: 8, right: 8),
                padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                child: TextFormField(
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
                  onChanged: (value) {
                    _fighter1 = value;
                  },
                )),
            // 選手2氏名入力
            Container(
                margin: EdgeInsets.only(top: 00, bottom: 10, left: 8, right: 8),
                padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                child: TextFormField(
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
                    showConfirmDialog();
                  },
                )),
          ],
        ),
      ),
    );
  }

  // 確認ダイアログ表示
  void showConfirmDialog() {
    String dialogText = "以下の試合情報を追加して宜しいですか？";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("試合情報追加"),
          content: Text(dialogText +
              "\n\n種目：${_sportsName}\n試合日：${_eventDate}\n大会名：${_eventName}\n${_fighter1} VS ${_fighter2}"),
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
