import 'dart:io';

import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

const String _baseUrl = 'http://honoo.xyz:3000';

class Request {
  static var _request;
  static _getRequest() {
    if (_request == null) {
      _request = Dio(BaseOptions(
        //   connectTimeout: 15000,
        // receiveTimeout: 15000,
        // responseType: ResponseType.plain,
        validateStatus: (status) {
          // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
          return true;
        },
        baseUrl: _baseUrl,
      ));
      () async {
        return await getApplicationDocumentsDirectory();
      }()
          .then((appDocDir) {
        var cookieJar = PersistCookieJar(dir: '${appDocDir.path}/.cookies/');
        print(appDocDir.path);
        _request.interceptors.add(CookieManager(cookieJar));
      });
    }
    return _request;
  }

  static Map formatReturn(bool ok, String msg, Map data) {
    return {
      'ok': ok,
      'msg': msg,
      'data': data,
    };
  }
}

final Dio request = Request._getRequest();
