import 'package:focus_music/components/player/playerController.dart';
import 'package:focus_music/api/music_api.dart';
import 'package:focus_music/utils/utils.dart';

class MusicService {
    static Future<String> getUrl(context, id) async {
    var urlRes = await MusicAPI.getSongUrl(id);
    if (urlRes['data']['url'] != null) {
      return urlRes['data']['url'];
    } else {
      Utils.message(context, content: urlRes["msg"]);
      return null;
    }
  }

  static List<LrcClip> packLrcData(String source) {
    List<LrcClip> res = [];
    var lrcs = source.split('\n');
    var emptyReg = RegExp('\\s');
    for (var lrc in lrcs) {
      var lrcClip = LrcClip();
      var splitMark = lrc.indexOf(']');
      if (splitMark == -1) {
        continue;
      }

      var time = lrc.substring(1, splitMark);
      int milliTime = 0;
      var spliceList = time.split(".");
      if (spliceList.length != 2) {
        continue;
      }
      milliTime += int.parse(spliceList[1].replaceAll(emptyReg, ''));
      var spliceList2 = spliceList[0].split(":");
      int radix = 0;
      for (int i = spliceList2.length - 1; i >= 0; i--) {
        int radixMulti = radix == 0 ? 1 : radix * 60;
        milliTime += int.parse(spliceList2[i]) * 1000 * radixMulti;
        radix++;
      }

      lrcClip.time = milliTime;

      if (splitMark + 1 < lrc.length) {
        var text = lrc.substring(splitMark + 1);
        lrcClip.text = text;
      }

      res.add(lrcClip);
    }
    res.sort((i1, i2) => i1.time.compareTo(i2.time));
    return res;
  }

  static Future<List<LrcClip>> getLrc(id) async {
    var lrcRes = await MusicAPI.getLrc(id);
    if (lrcRes['ok']) {
      return packLrcData(lrcRes['data']['lyric'].toString());
    }
    return null;
  }
}