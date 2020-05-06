import 'package:flutter/material.dart';
import 'package:focus_music/pages/home/test.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';
import '../../store/home.dart';
import '../../store/user.dart';
import './rank.dart';
import './likes.dart';
import './search.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin<HomeView> {
  @override
  bool get wantKeepAlive => true;

  Widget buildSearchBar() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SearchView()));
      },
      child: Container(
        height: 45,
        child: Row(children: <Widget>[
          Expanded(flex: 1, child: Icon(Icons.search)),
          Expanded(
            flex: 8,
            child: TextField(
                readOnly: true,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchView()));
                }),
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(children: [
        buildSearchBar(),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Utils.loadingWrapper(RankView()),
        ),
        Offstage(
          offstage: Provider.of<UserModel>(context).profile == null,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Utils.loadingWrapper(LikesView()),
          ),
        ),
        // Text('num: ${Provider.of<HomeModel>(context).theNum}'),
      ]),
    ));
  }
}
