import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_shop_flutter/models/Feedback.dart';
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

      ));
    }
    return FBs;
  }

  Future<bool> createFeedback(
      String email, String content,double rating, String proID) async {
    String fbID = randomAlphaNumeric(20).toString() + "pro" + proID;

    try {
      await Firestore.instance.collection('Feedback').document(fbID).setData({
        'email': email,
        'content': content,
        'proID': proID,
        'date': DateTime.now().toString(),
        'fbID': fbID,
        'rating': rating,
      });
    } catch (e) {
      print('------>' + e);
      return false;
    }
    return true;
  }
}
