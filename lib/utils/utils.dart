import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static Widget loadingWrapper(Widget w, [judgeItem = 'pass']) {
    if (w == null || judgeItem == null) {
      return Text('Loading');
    }
    return w;
  }

  static setLocalMap(name, value) async {
    var _prefs = await SharedPreferences.getInstance();
    _prefs.setString(name, jsonEncode(value));
  }

  static getLocalMap(name) async {
    var _prefs = await SharedPreferences.getInstance();
    return jsonDecode(_prefs.getString(name));
  }

  static message(context, {title, content, confirmText}) {
    showDialog(
        context: context,
        builder: (context) => Message(
              title: title,
              content: content,
              confirmText: confirmText,
            ));
  }

  static Size getDeviceSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}

class Message extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;

  Message({this.title, this.content, this.confirmText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this.title ?? ''),
      content: Text(this.content ?? ''),
      actions: <Widget>[
        FlatButton(
          child: Text(confirmText ?? '关闭'),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
