import 'dart:io';
import '../utils/request.dart';
import '../utils/utils.dart';
import '../utils/constant.dart';
import 'package:sprintf/sprintf.dart';
import 'package:path_provider/path_provider.dart';

class MusicAPI {
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

  static Future<Map> checkLoginStatus() async {
    try {
      // print(request.interceptors);
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

  static Future<Map> getRankDetails([idx = 1]) async {
    try {
      return await request.get('/top/list?idx=$idx').then((res) {
        if (res.statusCode == HttpStatus.ok) {
          var playmap = res.data['playlist'];
          return Request.formatReturn(true, '排行榜[$idx]获取成功', {
            "tracks": playmap['tracks'].sublist(0, 5),
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

  static Future<Map> like(id) async {
    try {
      return await request.post('/like', data: {"id": id}).then((res) {
        print(id);
        print(res);
        if (res.statusCode == HttpStatus.ok) {
          return Request.formatReturn(true, '喜欢成功', res.data);
        }
        return Request.formatReturn(false, res.data['msg'] ?? '喜欢失败', {});
      });
    } catch (e) {
      return Request.formatReturn(false, '喜欢错误', {});
    }
  }

  static Future<Map> unlike(id) async {
    try {
      return await request
          .post('/like', data: {"id": id, "like": "false"}).then((res) {
        if (res.statusCode == HttpStatus.ok) {
          return Request.formatReturn(true, '取消喜欢成功', res.data);
        }
        return Request.formatReturn(false, res.data['msg'] ?? '取消喜欢失败', {});
      });
    } catch (e) {
      return Request.formatReturn(false, '取消喜欢错误', {});
    }
  }

  static Future<Map> getLikeList([uid]) async {
    try {
      return await request
          .post('/likelist', data: uid != null ? {"uid": uid} : {})
          .then((res) async {
        if (res.statusCode == HttpStatus.ok) {
          if (res.data['ids'] != null && res.data['ids'].length > 0) {
            var songs = await getSongDetail(res.data['ids'].join(','));
            if (songs['ok']) {
              return Request.formatReturn(true, '成功', songs['data']);
            }
          } else {
            return Request.formatReturn(true, '成功', {});
          }
        }
        return Request.formatReturn(false, res.data['msg'] ?? '喜欢列表获取失败', {});
      });
    } catch (e) {
      return Request.formatReturn(false, '喜欢列表获取错误', {});
    }
  }

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
}
