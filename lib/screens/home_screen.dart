import 'package:flutter/material.dart';

import '../widgets/sample_message.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SampleMessage(),
    );
  }
}
