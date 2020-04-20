import 'package:flutter/material.dart';

class LrcView extends StatefulWidget {
@override
  State<StatefulWidget> createState() {
    return LrcViewState();
  }
}

class LrcViewState extends State<LrcView> with AutomaticKeepAliveClientMixin<LrcView> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Center(
        child: Text("lrc"),
      ),
    );
  }
}


