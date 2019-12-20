import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_shop_flutter/models/Feedback.dart';
import 'package:grocery_shop_flutter/models/Order.dart';
import 'package:grocery_shop_flutter/models/Receipt.dart';
import 'package:grocery_shop_flutter/repositories/OrderRepository.dart';
import 'package:grocery_shop_flutter/repositories/ReceiptRepository.dart';
import 'package:random_string/random_string.dart';

class FeedBackRepository {
  Future<List<FeedBack>> getFeedbackByID(String proID) async {
    List<FeedBack> FBs = [];
    var result = await Firestore.instance
        .collection('Feedback')
        .where("proID", isEqualTo: proID)
        .getDocuments();
    for (var fb in result.documents) {
      FBs.add(FeedBack(
        fb.data['proID'],
        fb.data['email'],
        fb.data['date'],
        fb.data['content'],
        fb.data['fbID'],
        fb.data['rating'],
        fb.data['invalid'],
      ));
    }
    return FBs;
  }

  Future<bool> createFeedback(
      String email, String content, double rating, String proID) async {
    String fbID = randomAlphaNumeric(20).toString() + "pro" + proID;

    try {
      await Firestore.instance.collection('Feedback').document(fbID).setData({
        'email': email,
        'content': content,
        'proID': proID,
        'date': DateTime.now().toString(),
        'fbID': fbID,
        'rating': rating,
        'invalid': 0,
      });
    } catch (e) {
      print('------> Err create feedback' + e);
      return false;
    }
    return true;
  }

  Future<bool> checkUserWasBought(String uid, String proID) async {
    try {
      List<Receipt> _lstUserReceiptDone =
          await ReceiptRepository().getUserReceiptDone(uid);
      for (var i in _lstUserReceiptDone) {
        List<Order> _lstOrderDetail =
            await OrderRepository().getOrderByReceiptID(i.receiptID);
        for (var j in _lstOrderDetail) {
          if (j.product.proID==proID) {
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      print('------> Err check User Was bought ' + e);
      return false;
    }
  }
}
