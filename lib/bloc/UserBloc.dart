import 'dart:math';

import 'package:grocery_shop_flutter/models/User.dart';
import 'package:grocery_shop_flutter/repositories/UserRepository.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  final _userRepo = UserRepository();
  static UserBloc _userBloc;
  PublishSubject<User> _publishSubjectUser;
  User _userInfo;

  User get userInfo => _userInfo;

  factory UserBloc() {
    if (_userBloc == null) _userBloc = new UserBloc._();

    return _userBloc;
  }

  UserBloc._() {
    _publishSubjectUser = new PublishSubject<User>();
  }

  Observable<User> get observableUser => _publishSubjectUser.stream;

  Future<bool> getUserInfo(String uID) async {
    try {
      _userInfo = await _userRepo.getUserInfo(uID);
      if (_userInfo != null) {
        _updateUser();
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> loginUser(String email, String password) async {
    try {
      _userInfo = await _userRepo.loginUser(email, password);
      if (_userInfo != null) {
        _updateUser();
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await _userRepo.logout();
      dispose();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> checkAuth() async {
    try {
      _userInfo = await _userRepo.checkAuth();
      if (_userInfo == null) return false;
      _updateUser();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateInfoUser(String userID, String fullname,
      String gender, String location, String phone) async {
    try {
      var _result = (await _userRepo.updateInfoUser(
          userID: userID,
          fullname: fullname,
          gender: gender,
          location: location,
          phone: phone));
      _updateUser();
      if (_result == false) {
        return false;
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updatePasswordUser(String userID, String password) async {
    try {
      var _result = (await _userRepo.updatePasswordUser(
          userID: userID, password: password));
      if (_result == false) {
        return false;
      }
      _updateUser();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateImageUser(String userID, String imgURL) async {
    try {
      var _result =
          (await _userRepo.updateImageURL(userID: userID, imgURL: imgURL));
      if (_result == false) {
        return false;
      }
      _userInfo.setImage(imgURL);
      _updateUser();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void _updateUser() {
    _publishSubjectUser.sink.add(_userInfo);
  }

  dispose() {
    _userBloc = null;
    _publishSubjectUser.close();
  }
}
