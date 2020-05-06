import 'package:flutter/foundation.dart';

class UserModel with ChangeNotifier {
  int _profile;
  List _likeList;
  UserModel([this._profile]);
  void updateProfile(profile) {
    _profile = profile;
    notifyListeners();
  }

  void updateLikeList(likeList) {
    _likeList = likeList;
    notifyListeners();
  }

  void reset() {
    _profile = null;
    _likeList = null;
    notifyListeners();
  }

  int get profile => _profile;
  List get likeList => _likeList;
}
