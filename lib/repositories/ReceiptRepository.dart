import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/models/Order.dart';
import 'package:grocery_shop_flutter/models/Receipt.dart';
import 'package:random_string/random_string.dart';
import 'dart:math';

class ReceiptRepository {
  Future<List<Receipt>> getAllReceipt() async {
    Firestore firestore = Firestore.instance;

    List<Receipt> receipts = [];
    var result = await firestore.collection('Receipt').getDocuments();
    for (var receipt in result.documents) {
      receipts.add(Receipt(
        receipt.data['deliveryAdd'],
        receipt.data['date'],
        receipt.data['userID'],
        receipt.data['totalPro'],
        receipt.data['totalPrice'],
        //receipt.data['orders'],
        receipt.data['status'],
        receipt.data['receiptID'],
      ));
    }
    return receipts;
  }

  Future<List<Receipt>> getUserReceiptDone(String userid) async {
    List<Receipt> userReceipts = [];
    var result = await Firestore.instance
        .collection('Receipt')
        .where('userID', isEqualTo: userid)
        .where('status', isEqualTo: 'Đã giao')
        .getDocuments();
    for (var receipt in result.documents) {
      userReceipts.add(Receipt(
        receipt.data['deliveryAdd'],
        receipt.data['date'],
        receipt.data['userID'],
        receipt.data['totalPro'],
        receipt.data['totalPrice'],
        //List.from(receipt.data['orders']),
        receipt.data['status'],
        receipt.data['receiptID'],
      ));
    }
    return userReceipts;
  }

  Future<List<Receipt>> getUserReceiptWaiting(String userid) async {
    List<Receipt> userReceipts = [];
    var result = await Firestore.instance
        .collection('Receipt')
        .where('userID', isEqualTo: userid)
        .where('status', isEqualTo: 'Đang giao')
        .getDocuments();
    for (var receipt in result.documents) {
      userReceipts.add(Receipt(
        receipt.data['deliveryAdd'],
        receipt.data['date'],
        receipt.data['userID'],
        receipt.data['totalPro'],
        receipt.data['totalPrice'],
        //List.from(receipt.data['orders']),
        receipt.data['status'],
        receipt.data['receiptID'],
      ));
    }
    return userReceipts;
  }

  Future<List<Receipt>> getUserReceiptPending(String userid) async {
    List<Receipt> userReceipts = [];
    var result = await Firestore.instance
        .collection('Receipt')
        .where('userID', isEqualTo: userid)
        .where('status', isEqualTo: 'Chờ xử lý')
        .getDocuments();
    for (var receipt in result.documents) {
      userReceipts.add(Receipt(
        receipt.data['deliveryAdd'],
        receipt.data['date'],
        receipt.data['userID'],
        receipt.data['totalPro'],
        receipt.data['totalPrice'],
        //List.from(receipt.data['orders']),
        receipt.data['status'],
        receipt.data['receiptID'],
      ));
    }
    return userReceipts;
  }

  Future<List<Receipt>> getUserReceiptCancel(String userid) async {
    List<Receipt> userReceipts = [];
    var result = await Firestore.instance
        .collection('Receipt')
        .where('userID', isEqualTo: userid)
        .where('status', isEqualTo: 'Đã hủy')
        .getDocuments();
    for (var receipt in result.documents) {
      userReceipts.add(Receipt(
        receipt.data['deliveryAdd'],
        receipt.data['date'],
        receipt.data['userID'],
        receipt.data['totalPro'],
        receipt.data['totalPrice'],
        //List.from(receipt.data['orders']),
        receipt.data['status'],
        receipt.data['receiptID'],
      ));
    }
    return userReceipts;
  }

  Future<bool> createdUserReceipt(
      {String deliveryAdd,
      List<Order> orders,
      String userID,
      int totalPrice,
      int totalPro}) async {
    try {
      String receiptID = randomAlphaNumeric(20).toString();
      var resultAddReceipt = await Firestore.instance
          .collection('Receipt')
          .document(receiptID)
          .setData({
        'date': DateTime.now().toString(),
        'deliveryAdd': deliveryAdd,
        'userID': userID,
        'totalPrice': totalPrice,
        'totalPro': totalPro,
        //'orders': orders,
        'status': "Chờ xử lý",
        'receiptID': receiptID,
      });

      for (Order o in orders) {
        String orderDetailID = randomAlphaNumeric(20).toString();
        var resultAddOrder = await Firestore.instance
            .collection('OrderDetail')
            .document(orderDetailID)
            .setData({
          'receiptID':receiptID,
          'orderDetaileID': orderDetailID,
          'proID': o.product.proID,
          'quantity': o.quantity,
          'orderPrice': o.orderPrice,
        });
      }
    } catch (e) {
      return notComplete();
    }
    return complete();
  }

  Future<bool> updateCancelReceipt({String receiptID}) async {
    try {
      var result = await Firestore.instance
          .collection('Receipt')
          .document(receiptID)
          .updateData({'status': 'Đã hủy'});
    } catch (e) {
      return notComplete();
    }
    return complete();
  }

  Future<bool> complete() async {
    return true;
  }

  Future<bool> notComplete() async {
    return false;
  }
}
