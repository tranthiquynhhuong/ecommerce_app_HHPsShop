import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_shop_flutter/models/Order.dart';
import 'package:grocery_shop_flutter/models/Product.dart';
import 'package:grocery_shop_flutter/repositories/ProductsRepository.dart';

class OrderRepository {
  Future<List<Order>> getOrderByReceiptID(String receiptID) async {
    List<Order> userOrders = [];
    Product product;
    var result = await Firestore.instance
        .collection('OrderDetail')
        .where('receiptID', isEqualTo: receiptID)
        .getDocuments();
    for (var o in result.documents) {
      product = await ProductsRepository().getProductByProIDAllCase(o.data['proID']);
      if(product!=null){
        userOrders.add(Order(
          product,
          o.data['quantity'],
          o.data['orderDetaileID'],
          o.data['orderPrice'],
        ));
      }
    }
    return userOrders;
  }

  Future<bool> complete() async {
    return true;
  }

  Future<bool> notComplete() async {
    return false;
  }
}
