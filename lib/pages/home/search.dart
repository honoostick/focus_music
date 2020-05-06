import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:focus_music/services/music.dart';
import 'package:toast/toast.dart';
import '../../api/music_api.dart';
import 'package:loading_animations/loading_animations.dart';
import '../../utils/utils.dart';
import '../../components/player/player.dart';

class SearchView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchViewState();
  }
}

class SearchViewState extends State<SearchView> {
  var songs = [];
  var _tec = TextEditingController();

  searchSongs(context, query) async {
    var res = await MusicAPI.serachSongs(query);
    if (res['ok'] && res['data'].isNotEmpty) {
      return res['data']['songs'];
    } else {
      Utils.message(context, content: res["msg"]);
    }
    return null;
  }

  buildSearchBar() {
    return Row(
      children: <Widget>[
        Expanded(
          child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        Expanded(
          flex: 7,
          child: TextField(
            controller: _tec,
            autofocus: true,
            onSubmitted: (query) async {
              BotToast.showLoading(backgroundColor: Colors.transparent);
              var res = await searchSongs(context, query.trim());
              BotToast.closeAllLoading();
              if (res != null) {
                setState(() {
                  songs = res;
                });
              }
            },
          ),
        ),
        Expanded(
          child: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _tec.text = "";
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
                child: Container(
              margin: EdgeInsets.only(top: 5),
              child: buildSearchBar(),
            )),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              child: Text('搜索结果(${songs.length})'),
            )),
            Expanded(flex: 15, child: SearchContentView(songs)),
          ],
        ),
      ),
    );
  }
}

class SearchContentView extends StatelessWidget {
  final List songs;
  SearchContentView(this.songs);

  Widget buildResultItem(context, v) {
    return Material(
        child: InkWell(
            onTap: () async {
              BotToast.showLoading(backgroundColor: Colors.transparent);
              var url = await MusicService.getUrl(context, v['id']);
              var lrcClips = await MusicService.getLrc(v['id']);
              BotToast.closeAllLoading();

              if (url == null) {
                Toast.show("失败", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                return;
              }

              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) =>
                        PlayerWidget(v['name'], lrcClips, url)),
              );
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border(
                      bottom: BorderSide(
                          width: 1, color: Theme.of(context).dividerColor)),
                ),
                child: Row(children: <Widget>[
                  Expanded(
                    child: Icon(Icons.music_note),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              v['name'],
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).accentColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            child: Text(
                              '${(v['artists'] != null && v['artists'].length > 0) ? v['artists'][0]['name'] : '-'}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ]),
                  )
                ]))));
  }

  @override
  Widget build(BuildContext context) {
    if (songs == null || songs.length == 0) {
      return Container(
          child: Center(
              child: Text(
        'Music Life',
        style: TextStyle(color: Theme.of(context).hintColor),
      )));
    }

    return ListView(
      children: songs.map((v) {
        return buildResultItem(context, v);
      }).toList(),
    );
  }
}
