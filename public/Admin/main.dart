import 'package:flutter/material.dart';
// lodash用に定義した処理を読み込む
import 'lodash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                // _.max() を呼び出す
                max([10, 20]).toString(),
                style: TextStyle(fontSize: 24),
              ),
              Text(
                // _.camelCase() を呼び出す
                camelCase('Foo Bar'),
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
