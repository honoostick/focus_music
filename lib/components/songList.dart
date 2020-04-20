import 'package:flutter/material.dart';
import 'package:focus_music/api/music_api.dart';
import 'package:focus_music/components/player/player.dart';
import '../utils/utils.dart';

class SongListWidget extends StatelessWidget {
  final List songs;
  final double listHeight;
  final ScrollController sc = ScrollController();
  SongListWidget(this.songs, [this.listHeight = 210]);

  Widget buildItem(ctx, item, order, isLast) {
    return Container(
      // height: 50,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: isLast ? EdgeInsets.only(bottom: 10) : null,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('$order'),
          ),
          Expanded(
            flex: 4,
            child: Utils.loadingWrapper(Image.network(
              item['al']['picUrl'],
              width: 50,
              height: 50,
            )),
          ),
          Expanded(
              flex: 24,
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        item['name'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        (item['ar'] != null && item['ar'].length > 0)
                            ? item['ar'][0]['name']
                            : '-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ))),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              MusicAPI.unlike(item['id']).then((res) {
                Utils.message(ctx, content: res["msg"]);
                // if (res["ok"]) {

                // }
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: listHeight,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Theme.of(context).cardColor,
        border: null,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      ),
      child: Utils.loadingWrapper(
          ListView.builder(
            controller: sc,
            // itemExtent: 90,
            padding: EdgeInsets.all(0),
            itemCount: songs.length,
            itemBuilder: (BuildContext context, int i) {
              // var list = <Widget>[];
              // if (songs != null) {
              //   for (int i = 0; i < songs.length; i++) {
              //     list.add(buildItem(songs[i], i + 1, i == songs.length));
              //   }
              // }
              // return list;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => PlayerWidget(songs[i]['name'], [],
                            'https://music.163.com/song/media/outer/url?id=${songs[i]['id']}.mp3')),
                  );
                },
                child: buildItem(context, songs[i], i + 1, i == songs.length),
              );
            },
          ),
          songs),
    );
  }
}
