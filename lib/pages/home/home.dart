import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';
import '../../store/home.dart';
import './rank.dart';
import './likes.dart';

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        child: SingleChildScrollView(
      child: Column(children: [
        Text('主页'),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Utils.loadingWrapper(RankView()),
        ),
        Offstage(
          offstage: false,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Utils.loadingWrapper(LikesView()),
          ),
        ),
        Text('num: ${Provider.of<HomeModel>(context).theNum}'),
      ]),
    ));
  }
}
