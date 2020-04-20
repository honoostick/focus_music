import 'package:flutter/material.dart';
import '../../api/music_api.dart';

class TestView extends StatelessWidget {
  TestView() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Text('热门'),
        MaterialButton(
            child: Text(
              '测试',
              style: TextStyle(color: Colors.purple, fontSize: 18),
            ),
            onPressed: () {
              MusicAPI.getRankDetails();
            }),
        StateView(),
      ]),
    );
  }
}

class StateView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StateViewState();
}

class StateViewState extends State<StateView> {
  final tc = TextEditingController();
  var sc = ScrollController();
  var testText = '1';
  var hotSongs = [];

  StateViewState() {
    MusicAPI.getRankDetails().then((res) {
      if (mounted && res != null) {
        setState(() {
          testText = (res['playlist'] != null) ? res['playlist']['name'] : '-';
          hotSongs = (res['playlist'] != null) ? res['playlist']['tracks'] : [];
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    testText = 'init';
  }

  Widget buildItem(item) {
    return Container(
      child: Row(
        children: [
          Expanded(
              child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(item['name']),
                Text((item['ar'] != null && item['ar'].length > 0)
                    ? item['ar'][0]['name']
                    : '-')
              ],
            ),
          )),
          Icon(Icons.more),
          Text('123')
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
          child: Text('$testText'),
        ),
        Container(
            height: 500,
            child: ListView(
              controller: sc,
              itemExtent: 50,
              padding: EdgeInsets.all(0),
              scrollDirection: Axis.vertical,
              children: () {
                var list = <Widget>[];
                for (int i = 0; i < hotSongs.length; i++) {
                  list.add(buildItem(hotSongs[i]));
                }
                return list;
              }(),
            )),
      ],
    ));
  }
}
