import 'package:flutter/material.dart';

class User {
  String _userID;
  String _fullname;
  String _email;
  String _password;
  String _gender;
  String _location;
  String _phone;
  String _signupdate;
  String _imgURL;
  int _isActive;

  User(this._userID, this._fullname, this._email, this._password, this._gender,
      this._signupdate, this._location, this._phone,this._imgURL,this._isActive);

  String get userID => _userID;
  String get fullname => _fullname;
  String get email => _email;
  String get password => _password;
  String get gender => _gender;
  String get location => _location;
  String get phone => _phone;
  String get signupdate => _signupdate;
  String get imgURL => _imgURL;
  int get isActive => _isActive;

  setImage(String url) {
    _imgURL = url;
  }
}
