import 'package:famitree/src/core/global/global_data.dart';
import 'package:famitree/src/data/models/user.dart';
import 'package:flutter/material.dart';

class CurrentUser extends ChangeNotifier {
  late MyUser _user;

  MyUser get user => _user;

  set user(MyUser value) {
    _user = value;
    GlobalData().listenAll();
    // notifyListeners();
  }

  void setName() {
    notifyListeners();
  }
  void setProfileImage() {
    notifyListeners();
  }
}