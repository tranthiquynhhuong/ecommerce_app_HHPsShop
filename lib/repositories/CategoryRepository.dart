import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_shop_flutter/models/Category.dart';

class CategoryRepository {
  Future<List<Category>> fetchAllCategories() async {
    List<Category> categories = [];
    var result = await Firestore.instance.collection('Category').getDocuments();
    for (var cat in result.documents) {
      categories.add(Category(
        cat.data['catID'],
        cat.data['name'],
        cat.data['imgURL'],
      ));
    }
    return categories;
  }
}
