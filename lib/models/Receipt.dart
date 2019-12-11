import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/models/Order.dart';

//class Receipt {
//  String _status;
//  String _receiptID;
//  String _deliveryAddress;
//  String _billDate;
//  String _userID;
//  int _totalPro;
//  int _totalPrice;
//  List<String> _listOrders;
//
//  Receipt(this._deliveryAddress, this._billDate, this._userID, this._totalPro,
//      this._totalPrice, this._listOrders, this._status, this._receiptID);
//
//  String get deliveryAddress => _deliveryAddress;
//  String get billDate => _billDate;
//  String get userID => _userID;
//  int get totalPro => _totalPro;
//  int get totalPrice => _totalPrice;
//  List<String> get listOrders => _listOrders;
//  String get status => _status;
//  String get receiptID => _receiptID;
//}

class Receipt {
  String _status;
  String _receiptID;
  String _deliveryAddress;
  String _billDate;
  String _userID;
  int _totalPro;
  int _totalPrice;
  int _phone;

  Receipt(this._deliveryAddress, this._billDate, this._userID, this._totalPro,
      this._totalPrice, this._status, this._receiptID,this._phone);

  String get deliveryAddress => _deliveryAddress;
  String get billDate => _billDate;
  String get userID => _userID;
  int get totalPro => _totalPro;
  int get totalPrice => _totalPrice;
  String get status => _status;
  String get receiptID => _receiptID;
  int get phone => _phone;

}
