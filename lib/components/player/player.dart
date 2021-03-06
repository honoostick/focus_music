import 'package:flutter/material.dart';
import 'dart:math';
import './playerController.dart';
// import '../api/lrcapi.dart';
import '../../utils/utils.dart';

class PlayerWidget extends StatefulWidget {
  final String title;
  final List<LrcClip> content;
  final String musicUrl;

  PlayerWidget(this.title, this.content, this.musicUrl);

  @override
  State<StatefulWidget> createState() =>
      PlayerWidgetState(title, content, musicUrl: musicUrl);
}

class PlayerWidgetState extends State<PlayerWidget>
    with SingleTickerProviderStateMixin {
  final String title;
  final List<LrcClip> content;
  final String musicUrl;
  final ScrollController sc = ScrollController();

  var player = PlayerController();
  var curPos = Duration(seconds: 0);
  var duration = Duration(seconds: 0);

  int probe = 0;
  double offset = 0;
  // List<MaterialButton> _lrcItems = [];

  PlayerWidgetState(this.title, this.content, {this.musicUrl}) {
    playerListen();
    // initLrcItems();
  }

  initLrcItems() {
    // for (var i = 0; i < content.length; i++) {
    //   _lrcItems.add(MaterialButton(
    //     child: Text(
    //       content[i].text,
    //       style: TextStyle(
    //           color: i == 0 ? Colors.purple[300] : Colors.white, fontSize: 16),
    //     ),
    //     onPressed: () {},
    //   ));
    // }
  }

  playerListen() {
    player.player.onAudioPositionChanged.listen((d) {
      setState(() {
        curPos = d;
        updateProbe(d);
      });
    });

    player.player.onDurationChanged.listen((d) {
      setState(() {
        this.duration = d;
      });
    });

    player.player.onPlayerStateChanged.listen((s) {});
  }

  updateProbe(Duration d) {
    int index = content.length - 1;
    for (int i = 0; i < content.length - 1; i++) {
      if (content[i + 1].time > d.inMilliseconds) {
        index = i;
        break;
      }
    }

    // 50 * (probe - 5).toDouble() - position
    if (probe != index) {
      setState(() {
        probe = index;
        if (probe > 5 && probe < content.length - 6) {
          // sc.jumpTo(50 * (probe - 5).toDouble() * anim.value);
          // sc.jumpTo(sc.position. + 50 * ac.value);
          sc.animateTo(50 * (probe - 5).toDouble(),
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        } else if (probe < 5) {
          // sc.jumpTo(0);
        }
      });

      //probe == i
      // if (probe > 0) {
      //   setState(() {
      //     _lrcItems[probe - 1] = MaterialButton(
      //       child: Text(
      //         content[probe - 1].text,
      //         style: TextStyle(color: Colors.white, fontSize: 16),
      //       ),
      //       onPressed: () {},
      //     );
      //   });
      // }
      // if (probe < _lrcItems.length) {
      //   setState(() {
      //     _lrcItems.clear();
      //     // _lrcItems[probe] = MaterialButton(
      //     //   child: Text(
      //     //     content[probe].text,
      //     //     style: TextStyle(color: Colors.purple[300], fontSize: 18),
      //     //   ),
      //     //   onPressed: () {},
      //     // );
      //   });
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 25),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
            // Text(musicUrl == null ? "No Url" : musicUrl),
            Expanded(
              child: ListView(
                itemExtent: 50,
                controller: sc,
                children: () {
                  var tmp = List<Widget>();
                  if (content == null) {
                    return [];
                  }
                  
                  for (var i = 0; i < content.length; i++) {
                    if (probe == i) {
                      tmp.add(MaterialButton(
                        child: Text(
                          content[i].text,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 23),
                        ),
                        onPressed: () {},
                      ));
                    } else
                      tmp.add(MaterialButton(
                        child: Text(
                          content[i].text,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Theme.of(context).backgroundColor,
                              fontSize: 17),
                        ),
                        onPressed: () {},
                      ));
                  }
                  return tmp;
                }(),
              ),
            ),

            // Text(
            //   content.toString(),
            //   style: TextStyle(fontSize: 18),
            // ),

            // Row(
            //   children: <Widget>[
            //     // progressBar(),
            //     Expanded(
            //       child: Container(
            //         decoration: BoxDecoration(border: Border.all(width: 1)),
            //         child: Transform.rotate(
            //           angle: pi / 2,
            //           child: progressBar(),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
        Positioned(
          bottom: 0.0,
          height: 5,
          width: Utils.getDeviceSize(context).width,
          child: progressBar(),
        ),
        Positioned(
          bottom: 0,
          right: -5,
          child: playButton(),
        )
      ]),
    );
  }

  Widget playButton() {
    return IconButton(
        icon: Icon(
          () {
            switch (player.state) {
              case PlayState.Playing:
                return Icons.pause;
              case PlayState.None:
                return Icons.play_arrow;
              case PlayState.Pause:
                return Icons.play_arrow;
              case PlayState.Stop:
                return Icons.play_arrow;
              default:
                return Icons.play_arrow;
            }
          }(),
          size: 35,
        ),
        onPressed: () {
          try {
            setState(() {
              switch (player.state) {
                case PlayState.Playing:
                  player.pause();
                  break;
                case PlayState.None:
                  if (musicUrl == null) {
                    Utils.message(context, content: '播放链接为空');
                    return;
                  }
                  player.play(musicUrl);
                  break;
                case PlayState.Pause:
                  player.resume();
                  break;
                case PlayState.Stop:
                  player.resume();
                  break;
                default:
              }
            });
          } catch (e) {
            Utils.message(context, content: '播放出错');
          }
        });
  }

  Widget progressBar() {
    return LinearProgressIndicator(
      value:
          duration.inSeconds == 0 ? 0 : curPos.inSeconds / duration.inSeconds,
      semanticsLabel: "111",
    );
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }
}
