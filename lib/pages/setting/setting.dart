import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../store/home.dart';
import '../../utils/utils.dart';
import './login.dart';
import '../../api/music_api.dart';

class SettingView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingViewState();
  }
}

class SettingViewState extends State<SettingView>
    with AutomaticKeepAliveClientMixin<SettingView> {
  var profile;
  var profileLoading = true;

  SettingViewState() {
    checkLogin();
  }

  @override
  bool get wantKeepAlive => true;

  checkLogin() {
    return MusicAPI.checkLoginStatus().then((res) {
      var data = res['data'];
      if (res['ok'] && data.isNotEmpty) {
        setState(() {
          profile = data['profile'];
        });
      }
      setState(() {
        profileLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget profileView;
    Widget logoutView;
    if (profileLoading) {
      profileView = Text('Loading');
      logoutView = Text('Loading');
    } else {
      var hasProfile = profile != null && profile.length != 0;
      profileView = MaterialButton(
        onPressed: () {
          if (hasProfile) {
            MusicAPI.logout();
          } else {
            Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => LoginView()),
            );
          }
        },
        color: Theme.of(context).primaryColor,
        child: Text(hasProfile ? '退出登录' : '登录'),
      );
      logoutView = Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Text(hasProfile ? '${profile['nickname']}' : '请登录'));
    }

    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          logoutView,
          profileView,
          MaterialButton(
            onPressed: () {
              Provider.of<HomeModel>(context, listen: false).add();
            },
            child: Text('add'),
          )
        ]),
      ),
    );
  }
}
