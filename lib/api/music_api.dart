import 'dart:io';
import 'package:focus_music/store/user.dart';
import 'package:provider/provider.dart';

import '../utils/request.dart';
import '../utils/utils.dart';
import '../utils/constant.dart';
import 'package:sprintf/sprintf.dart';
import 'package:path_provider/path_provider.dart';

class MusicAPI {
  // 用户
  /*
   * 登录
   */
  static Future<Map> login(phone, password) async {
    try {
      return await request.post('/login/cellphone',
          data: {"phone": phone, "password": password}).then((res) {
        if (res.statusCode == HttpStatus.ok) {
          Utils.setLocalMap(LocalData.M_PROFILE_LOGIN, res.data);
          return Request.formatReturn(true, '登录成功', res.data);
        }
        return Request.formatReturn(false, res.data['msg'] ?? '登录失败', {});
      });
    } catch (e) {
      return Request.formatReturn(false, '登录错误', {});
    }
  }

  /*
   * 登出
   */
  static Future<Map> logout() async {
    try {
      return await request.post('/logout').then((res) {
        if (res.statusCode == HttpStatus.ok) {
          return Request.formatReturn(true, '登出成功', res.data);
        }
        return Request.formatReturn(false, res.data['msg'] ?? '登出失败', {});
      });
    } catch (e) {
      return Request.formatReturn(false, '登出错误', {});
    }
  }

  /*
   * 检查登录状态
   */
  static Future<Map> checkLoginStatus() async {
    try {
      return await request.post('/login/status').then((res) {
        if (res.statusCode == HttpStatus.ok) {
          Utils.setLocalMap(LocalData.M_PROFILE_CHECK, res.data);
          return Request.formatReturn(true, '当前已登录', res.data);
        }
        return Request.formatReturn(false, res.data['msg'] ?? '登录检查失败', {});
      });
    } catch (e) {
      return Request.formatReturn(false, '登录检查错误', {});
    }
  }

  // 歌曲
  /*
   * 获取排行榜
   */
  static Future<Map> getRankDetails(List likeList, [idx = 1]) async {
    try {
      return await request.get('/top/list?idx=$idx').then((res) {
        if (res.statusCode == HttpStatus.ok) {
          var playmap = res.data['playlist'];
          var tracks = playmap['tracks'].sublist(0, 5);
          for (int i = 0; i < tracks.length; i++) {
            tracks[i]['isLike'] = likeList.contains(tracks[i]['id']);
          }
          return Request.formatReturn(true, '排行榜[$idx]获取成功', {
            "tracks": tracks,
            "coverImgUrl": playmap['coverImgUrl'],
            "name": playmap['name'],
          });
        }
        return Request.formatReturn(false, res.data['msg'] ?? '排行榜获取失败', {});
      });
    } catch (e) {
      return Request.formatReturn(false, '排行榜获取错误', {});
    }
  }

  /*
   * 收藏
   */
  static Future<Map> fav(id) async {
    try {
      return await request.post('/like', data: {"id": id}).then((res) async {
        print(id);
        print(res);
        if (res.statusCode == HttpStatus.ok) {
          // 刷新列表
          await getLikeList();
          return Request.formatReturn(true, '收藏成功', res.data);
        }
        return Request.formatReturn(false, res.data['msg'] ?? '收藏失败', {});
      });
    } catch (e) {
      return Request.formatReturn(false, '收藏错误', {});
    }
  }

  /*
   * 取消收藏
   */
  static Future<Map> cancelFav(id) async {
    try {
      return await request
          .post('/like', data: {"id": id, "like": "false"}).then((res) async {
        if (res.statusCode == HttpStatus.ok) {
          // 刷新列表
          await getLikeList();
          return Request.formatReturn(true, '取消收藏成功', res.data);
        }
        return Request.formatReturn(false, res.data['msg'] ?? '取消收藏失败', {});
      });
    } catch (e) {
      return Request.formatReturn(false, '取消收藏错误', {});
    }
  }

  /*
   * 收藏列表 
   */
  static Future<Map> getLikeList([uid]) async {
    try {
      return await request
          .post('/likelist', data: uid != null ? {"uid": uid} : {})
          .then((res) async {
        if (res.statusCode == HttpStatus.ok) {
          if (res.data['ids'] != null && res.data['ids'].length > 0) {
            var songs = await getSongDetail(res.data['ids'].join(','));
            // Provider.of<UserModel>(, listen: false).updateProfile(res.data['data']['profile']);
            if (songs['ok']) {
              return Request.formatReturn(true, '成功', songs['data']);
            }
          } else {
            return Request.formatReturn(true, '成功', {});
          }
        }
        return Request.formatReturn(false, res.data['msg'] ?? '收藏列表获取失败', {});
      });
    } catch (e) {
      return Request.formatReturn(false, '收藏列表获取错误', {});
    }
  }

  /*
   * 获取歌曲详情
   */
  static Future<Map> getSongDetail(String ids) async {
    try {
      return await request
          .get('/song/detail', queryParameters: {"ids": ids}).then((res) {
        if (res.statusCode == HttpStatus.ok) {
          return Request.formatReturn(true, '成功', res.data);
        }
        return Request.formatReturn(false, res.data['msg'] ?? '歌曲详情获取失败', {});
      });
    } catch (e) {
      return Request.formatReturn(false, '歌曲详情获取错误', {});
    }
  }

  // 可以缓存
  /*
   * 获取歌曲URL
   */
  static Future<Map> getSongUrl(var id) async {
    try {
      return await request
          .get('/song/url', queryParameters: {"id": id}).then((res) {
        if (res.statusCode == HttpStatus.ok &&
            res.data['data'].length > 0 &&
            res.data['data'][0]['url'] != null) {
          return Request.formatReturn(true, '成功', res.data['data'][0]);
        }
        return Request.formatReturn(
            false, res.data['msg'] ?? '失败：无法获取歌曲文件', {});
      });
    } catch (e) {
      return Request.formatReturn(false, '错误：无法获取歌曲文件', {});
    }
  }

  // /lyric?id=33894312
  /*
   * 获取歌词
   */
  static Future<Map> getLrc(var id) async {
    try {
      return await request
          .get('/lyric', queryParameters: {"id": id}).then((res) {
        if (res.statusCode == HttpStatus.ok &&
            res.data['lrc'] != null &&
            res.data['lrc'].length > 0) {
          return Request.formatReturn(true, '成功', res.data['lrc']);
        }
        return Request.formatReturn(false, res.data['msg'] ?? '歌词获取失败', {});
      });
    } catch (e) {
      return Request.formatReturn(false, '歌词获取错误', {});
    }
  }

  /*
   * 搜索歌曲
   */
  static Future<Map> serachSongs(String keywords) async {
    try {
      return await request
          .get('/search', queryParameters: {"keywords": keywords}).then((res) {
        if (res.statusCode == HttpStatus.ok &&
            res.data['result'] != null &&
            res.data['result'].length > 0) {
          return Request.formatReturn(true, '成功', res.data['result']);
        }
        return Request.formatReturn(false, res.data['msg'] ?? '搜索失败', {});
      });
    } catch (e) {
      return Request.formatReturn(false, '搜索错误', {});
    }
  }
}
