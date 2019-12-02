import 'package:grocery_shop_flutter/models/Product.dart';

class Order {
  Product _product;
  int _quantity;
  int _id;
  int _orderPrice;

  Order(this._product, this._quantity, this._id, this._orderPrice);

  int get id => _id;

  int get quantity => _quantity;

  Product get product => _product;

  int get orderPrice => _quantity * _orderPrice;
}
