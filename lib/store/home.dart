import 'package:flutter/foundation.dart';

class HomeModel with ChangeNotifier {
  int _theNum;
  HomeModel(this._theNum);
  void add() {
    _theNum++;
    notifyListeners();
  }
  void reduction(){
    _theNum--;
    notifyListeners();
  }
  int get theNum => _theNum;
}