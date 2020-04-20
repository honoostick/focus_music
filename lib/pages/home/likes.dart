import 'package:flutter/material.dart';
import '../../components/songList.dart';
import '../../api/music_api.dart';
import '../../utils/constant.dart';
import '../../utils/utils.dart';

class LikesView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LikesViewState();
  }
}

class LikesViewState extends State<LikesView>
    with SingleTickerProviderStateMixin {
  Widget rankWidget;
  List songs;

  LikesViewState() {
    if (songs == null || songs.length == 0) {
      getLikeList();
    }
  }

  getLikeList([uid]) {
    MusicAPI.getLikeList(uid).then((res) {
      if (res['ok'] && res['data'].isNotEmpty) {
        setState(() {
          songs = res['data']['songs'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).cardColor,
            border: Border.all(width: 0, color: Theme.of(context).cardColor),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        ),
        Utils.loadingWrapper(SongListWidget(songs), songs),
      ],
    );
  }
}
