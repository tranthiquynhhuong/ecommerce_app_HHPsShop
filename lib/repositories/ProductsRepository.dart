import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_shop_flutter/models/Product.dart';

class ProductsRepository {
  Future<List<Product>> fetchAllProducts() async {
    List<Product> products = [];
    var result = await Firestore.instance.collection('Product').getDocuments();
    for (var pro in result.documents) {
      products.add(Product(
        pro.data['proID'],
        pro.data['catID'],
        pro.data['name'],
        pro.data['description'],
        pro.data['imgURL'],
        pro.data['price'],
        pro.data['volumetric'],
        pro.data['quantity'],
        pro.data['isSale'],
        pro.data['discount'],
        pro.data['startSale'],
        pro.data['endSale'],
        pro.data['date'],
      ));
    }
    return products;
  }

  Future<Product> getProductByProID(String proID) async {
    Product product;
    var result = await Firestore.instance
        .collection('Product')
        .where('proID', isEqualTo: proID)
        .getDocuments();
    for (var pro in result.documents) {
      product = new Product(
        pro.data['proID'],
        pro.data['catID'],
        pro.data['name'],
        pro.data['description'],
        pro.data['imgURL'],
        pro.data['price'],
        pro.data['volumetric'],
        pro.data['quantity'],
        pro.data['isSale'],
        pro.data['discount'],
        pro.data['startSale'],
        pro.data['endSale'],
        pro.data['date'],
      );
    }
    return product;
  }

  Future<List<Product>> getProductSale() async {
    List<Product> products = [];
    var result = await Firestore.instance
        .collection('Product')
        .where('isSale', isEqualTo: 1)
        .getDocuments();
    for (var pro in result.documents) {
      products.add(Product(
        pro.data['proID'],
        pro.data['catID'],
        pro.data['name'],
        pro.data['description'],
        pro.data['imgURL'],
        pro.data['price'],
        pro.data['volumetric'],
        pro.data['quantity'],
        pro.data['isSale'],
        pro.data['discount'],
        pro.data['startSale'],
        pro.data['endSale'],
        pro.data['date'],
      ));
    }
    return products;
  }

  Future<List<Product>> getProductByCategory(String catID) async {
    List<Product> products = [];
    var result = await Firestore.instance
        .collection('Product')
        .where('catID', isEqualTo: catID)
        .getDocuments();
    for (var pro in result.documents) {
      products.add(Product(
        pro.data['proID'],
        pro.data['catID'],
        pro.data['name'],
        pro.data['description'],
        pro.data['imgURL'],
        pro.data['price'],
        pro.data['volumetric'],
        pro.data['quantity'],
        pro.data['isSale'],
        pro.data['discount'],
        pro.data['startSale'],
        pro.data['endSale'],
        pro.data['date'],
      ));
    }
    return products;
  }

  Future<Product> searchProductByName(String pro_name) async {
    Product product;
    var result = await Firestore.instance
        .collection('Product')
        .where('name', isEqualTo: pro_name)
        .getDocuments();
    for (var pro in result.documents) {
      product = new Product(
        pro.data['proID'],
        pro.data['catID'],
        pro.data['name'],
        pro.data['description'],
        pro.data['imgURL'],
        pro.data['price'].toInt(),
        pro.data['volumetric'].toInt(),
        pro.data['quantity'].toInt(),
        pro.data['isSale'].toInt(),
        pro.data['discount'].toInt(),
        pro.data['startSale'],
        pro.data['endSale'],
        pro.data['date'],
      );
    }
    return product;
  }

  Future<bool> updateQuantityAfterBuy(Product product, int quantityBuy) {
    try {
      Firestore.instance
          .collection('Product')
          .document(product.proID)
          .updateData({'quantity': product.quantity - quantityBuy});
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
