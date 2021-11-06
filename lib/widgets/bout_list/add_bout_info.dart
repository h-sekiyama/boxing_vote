import 'package:boxing_vote/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Functions.dart';

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
            Text("試合予定を追加する事ができます。皆さんが勝敗予想を楽しめる様、正しい試合情報を投稿して頂けます様にお願い致します。"),
            // 種目選択
            Container(
                padding: EdgeInsets.fromLTRB(0, 6, 0, 0),
                child: DropdownButton<String>(
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 30,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    underline: Container(
                      height: 0.5,
                      color: Colors.black,
                    ),
                    items: _items,
                    value: _sportsName,
                    onChanged: (value) => {
                          setState(() {
                            _sportsName = value.toString();
                          })
                        })),
            //試合日選択
            TextFormField(
              autofocus: false,
              style: new TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              decoration: new InputDecoration(
                hintText: "${_eventDate}",
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
                ))!;
                setState(() {
                  _eventDate = Functions.dateToString(_selectedDate!);
                });
                FocusManager.instance.primaryFocus!.unfocus();
              },
            ),
            // 大会名入力
            TextFormField(
              autofocus: false,
              style: new TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              decoration: new InputDecoration(
                hintText: '大会名',
              ),
              onChanged: (value) {
                _eventName = value;
              },
            ),
            // 選手1氏名入力
            TextFormField(
              autofocus: false,
              style: new TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              decoration: new InputDecoration(
                hintText: '選手1氏名',
              ),
              onChanged: (value) {
                _fighter1 = value;
              },
            ),
            // 選手2氏名入力
            TextFormField(
              autofocus: false,
              style: new TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              decoration: new InputDecoration(
                hintText: '選手2氏名',
              ),
              onChanged: (value) {
                _fighter2 = value;
              },
            ),
            // 試合追加ボタン
            Column(children: [
              ElevatedButton(
                child: Text("追加する"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                ),
                onPressed: () {
                  showConfirmDialog();
                },
              )
            ]),
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
            FlatButton(
              child: Text("やめる"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
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
                      "vote1_1": 0,
                      "vote1_2": 0,
                      "vote2_1": 0,
                      "vote2_2": 0,
                    }))
                    .then((value) => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()))
                        })
              },
            ),
          ],
        );
      },
    );
  }
}
