import 'package:flutter/material.dart';
import '../../utils/utils.dart';
import '../../api/music_api.dart';

class LoginView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      width: 300,
      height: 300,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Text(
                    '手机号码',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: _phoneController,
                  ),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Text(
                    '密码',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                  ),
                )
              ],
            ),
            MaterialButton(
              onPressed: () {
                MusicAPI.login(_phoneController.text, _passwordController.text)
                    .then((res) {
                  Utils.message(context, content: res["msg"]);
                  if (res["ok"]) {
                  } else {}
                });
              },
              child: Text('登录'),
            )
          ]),
    )));
  }
}
