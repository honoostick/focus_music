import 'package:flutter/material.dart';
import './pages/home/home.dart';
import './pages/lrc/lrc.dart';
import './pages/setting/setting.dart';

class Router extends StatefulWidget {
  Router({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RouterState createState() => _RouterState();
}

class _RouterState extends State<Router> {
  int navIndex = 0;
  PageController _pc = PageController();
  List<Widget> _pages = [HomeView(), LrcView(), SettingView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pc,
        children: _pages,
      ), // IndexedStack
      bottomNavigationBar: BottomNavigationBar(
        key: Key("bottom_navbar"),
        currentIndex: navIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("主页")),
          BottomNavigationBarItem(icon: Icon(Icons.info), title: Text("歌词")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("设置")),
        ],
        fixedColor: Theme.of(context).primaryColor,
        onTap: (index) {
          setState(() {
            navIndex = index;
          });
          _pc.jumpToPage(index);
        },
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
