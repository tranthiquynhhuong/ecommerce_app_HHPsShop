import 'package:grocery_shop_flutter/models/Product.dart';

class Order {

  Product _product;
  int _quantity;
  String _id;
  int _orderPrice;

  Order(this._product, this._quantity, this._id, this._orderPrice);

  String get id => _id;

  int get quantity => _quantity;

  Product get product => _product;

  int get orderPrice => _orderPrice;
}
