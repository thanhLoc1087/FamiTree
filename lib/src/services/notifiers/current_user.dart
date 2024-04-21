import 'package:famitree/src/data/models/user.dart';
import 'package:flutter/material.dart';

class CurrentUser extends ChangeNotifier {
  late MyUser _user;

  MyUser get user => _user;

  set user(MyUser value) {
    _user = value;
    // notifyListeners();
  }

  void setName() {
    notifyListeners();
  }
  void setProfileImage() {
    notifyListeners();
  }
}