import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Functions.dart';
import '../screens/chat_screen.dart';

class BoutDetail extends StatefulWidget {
  BoutDetail(this.id);
  String id;
  @override
  _MyFirestorePageState createState() => _MyFirestorePageState();
}

class _MyFirestorePageState extends State<BoutDetail> {
  String boutName = "";
  String fighter1 = "";
  String fighter2 = "";
  DateTime fightDate = DateTime.now();

  void initState() {
    fetchBoutData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Card(
              child: Column(children: [
                Text('${Functions.dateToString(fightDate)}'),
                Text('${boutName}'),
                Text('${fighter1} VS ${fighter2}'),
              ]),
            )
          ],
        ),
      ),
    );
  }

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
        fightDate = ref.get("fight_date");
      });
    });
  }
}
