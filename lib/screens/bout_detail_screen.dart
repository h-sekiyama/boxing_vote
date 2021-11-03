import 'package:boxing_vote/widgets/bout_list/bouts_detail.dart';
import 'package:flutter/material.dart';
import '../Tabs.dart';

class BoutDetailScreen extends StatelessWidget {
  BoutDetailScreen(this.id);
  String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [],
        ),
        body: BoutDetail(id),
        bottomNavigationBar: Tabs());
  }
}
