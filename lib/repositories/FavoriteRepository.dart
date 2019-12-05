import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_shop_flutter/models/Favorite.dart';
import 'package:random_string/random_string.dart';

class FavoriteRepository {
  Future<List<Favorite>> getFavoriteOfUser(String userID) async {
    List<Favorite> favors = [];
    var result = await Firestore.instance
        .collection('Favorite')
        .where("userID", isEqualTo: userID)
        .getDocuments();
    for (var fv in result.documents) {
      favors.add(Favorite(
        fv.data['favoriteID'],
        fv.data['proID'],
        fv.data['userID'],
        fv.data['date'],
      ));
    }
    return favors;
  }

  Future<bool> createFavorite(String proID, String userID) async {
    try {
      String fvID = randomAlphaNumeric(20).toString();

      await Firestore.instance.collection('Favorite').document(fvID).setData({
        'favoriteID': fvID,
        'proID': proID,
        'userID': userID,
        'date': DateTime.now().toString(),
      });
    } catch (e) {
      print('------>' + e);
      return false;
    }
    return true;
  }

  Future<Favorite> searchFavoriteByUserAndProduct(String proID, String userID)async{
    Favorite favorite;
    var result = await Firestore.instance
        .collection('Favorite')
        .where("userID", isEqualTo: userID)
        .where("proID", isEqualTo: proID)
        .getDocuments();
    for (var fv in result.documents) {
      favorite = new Favorite(
        fv.data['favoriteID'],
        fv.data['proID'],
        fv.data['userID'],
        fv.data['date'],
      );
    }
    return favorite;
  }

  Future<bool> deleteFavorite(String userID, String proID) async {
    try {
      Favorite favorite;
      var result = await Firestore.instance
          .collection('Favorite')
          .where("userID", isEqualTo: userID)
          .where("proID", isEqualTo: proID)
          .getDocuments();
      for (var fv in result.documents) {
        favorite = new Favorite(
          fv.data['favoriteID'],
          fv.data['proID'],
          fv.data['userID'],
          fv.data['date'],
        );
      }
      await Firestore.instance.collection('Favorite').document(favorite.favoriteID).delete();
    } catch (e) {
      print('------>' + e);
      return false;
    }
    return true;
  }

  Future<bool> checkIsFavorite(String userID, String proID) async {
    try {
      Favorite favorite;
      var result = await Firestore.instance
          .collection('Favorite')
          .where("userID", isEqualTo: userID)
          .where("proID", isEqualTo: proID)
          .getDocuments();
      for (var fv in result.documents) {
        favorite = new Favorite(
          fv.data['favoriteID'],
          fv.data['proID'],
          fv.data['userID'],
          fv.data['date'],
        );
      }
      if (favorite == null) {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }
}
