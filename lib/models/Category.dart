import 'package:flutter/material.dart';

class Category {
  String _imgURL;
  String _catID;
  String _name;
  //int _quantity;

  Category(this._catID, this._name, this._imgURL);

  String get catID => _catID;
  String get name => _name;
  String get imgURL => _imgURL;
  //int get quantity => _quantity;

}
