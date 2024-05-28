import 'package:famitree/src/core/global/global_data.dart';
import 'package:famitree/src/data/models/user.dart';
import 'package:flutter/material.dart';

class CurrentUser extends ChangeNotifier {
  static final CurrentUser _instance = CurrentUser._internal();

  factory CurrentUser() => _instance;
  late MyUser _user;

  MyUser get user => _user;

  set user(MyUser value) {
    _user = value;
    GlobalData().listenAll();
    // notifyListeners();
  }

  void setTreeCode(String treeCode) {
    user = user.copyWith(
      oldCode: user.treeCode,
      treeCode: treeCode,
    );
  }

  void setName() {
    notifyListeners();
  }
  void setProfileImage() {
    notifyListeners();
  }
  
  CurrentUser._internal();
}