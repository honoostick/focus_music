import 'package:flutter/material.dart';
import 'package:focus_music/store/user.dart';
import 'package:provider/provider.dart';
import '../../components/songList.dart';
import '../../api/music_api.dart';
import '../../utils/constant.dart';
import '../../utils/utils.dart';

class RankView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RankViewState();
  }
}

class RankViewState extends State<RankView>
    with SingleTickerProviderStateMixin {
  Widget rankWidget;
  List<DropdownMenuItem> curDropItems = [];
  String title;
  String coverImgUrl;
  List tracks;
  TabController _tc;
  int _selectRank = 0;

  RankViewState() {
    _tc = TabController(length: 3, vsync: this);

    Constant.RANK_TYPE.forEach((i, v) {
      curDropItems.add(buildDropItem(i, v));
    });

    if (tracks == null || tracks.length == 0) {
      getRank(Provider.of<UserModel>(context).likeList, 0);
    }
  }

  refreshPage() {
    _tc = TabController(length: 3, vsync: this);

    Constant.RANK_TYPE.forEach((i, v) {
      curDropItems.add(buildDropItem(i, v));
    });

    if (tracks == null || tracks.length == 0) {
      getRank(Provider.of<UserModel>(context).likeList, 0);
    }
  }

  getRank(likeList, [idx = 1]) {
    print(likeList);
    MusicAPI.getRankDetails(likeList??[], idx).then((res) {
      var data = res['data'];
      if (res['ok'] && data.isNotEmpty) {
        setState(() {
          title = data['name'];
          tracks = data['tracks'];
          coverImgUrl = data['coverImgUrl'];
        });
      }
    });
  }

  buildDropItem(i, v) {
    return DropdownMenuItem(
      child: Text('$v', style: TextStyle(fontSize: 10)),
      value: i,
    );
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Utils.loadingWrapper(
                  Image.network(
                    '$coverImgUrl',
                    width: 60,
                    height: 60,
                  ),
                  coverImgUrl),
              DropdownButton(
                style: TextStyle(
                  fontSize: 15,
                  color: Theme.of(context).textTheme.button.color,
                ),
                focusColor: Theme.of(context).primaryColor,
                value: _selectRank,
                items: curDropItems,
                onChanged: (v) {
                  setState(() {
                    _selectRank = v;
                  });
                  getRank(v);
                },
              ),
            ],
          ),
        ),
        Utils.loadingWrapper(SongListWidget(tracks), tracks),
      ],
    );
  }
}
