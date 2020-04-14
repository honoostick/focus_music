import 'package:flutter/material.dart';
import './hot_widget.dart';
import './test.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text('主页'),
            HotSongsView(),
          ]
        ),
      ),
    );
  }
}
