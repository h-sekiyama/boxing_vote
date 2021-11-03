import 'package:flutter/material.dart';
import '../Tabs.dart';
import '../widgets/bout_list/bouts_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [],
        ),
        body: BoutsList(),
        bottomNavigationBar: Tabs());
  }
}
