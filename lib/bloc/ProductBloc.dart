//import 'package:grocery_shop_flutter/models/Category.dart';
//import 'package:grocery_shop_flutter/models/Product.dart';
//import 'package:grocery_shop_flutter/repositories/CategoryRepository.dart';
//import 'package:grocery_shop_flutter/repositories/ProductsRepository.dart';
//import 'package:rxdart/rxdart.dart';
//
//class ProductBloc {
//  final _proRepo = ProductsRepository();
//  static ProductBloc _productBloc;
//
//  PublishSubject<Product> _publishSubjectProduct;
//  Product _product;
//  Product get product => _product;
//
//  factory ProductBloc() {
//    if (_productBloc == null) _productBloc = new ProductBloc._();
//
//    return _productBloc;
//  }
//
//  ProductBloc._() {
//    _publishSubjectProduct = new PublishSubject<Product>();
//  }
//
//  Observable<Product> get observableProduct => _publishSubjectProduct.stream;
//
//  Future<Product> getProductByID(String proID) async {
//    try {
//      _product = await _proRepo.getProductByProID(proID);
//      if (_product != null) {
//        _updateProduct();
//      }
//    } catch (e) {
//      print(e);
//    }
//  }
//
//  void _updateProduct() {
//    _publishSubjectProduct.sink.add(_product);
//  }
//
//  dispose() {
//    _productBloc = null;
//    _publishSubjectProduct.close();
//  }
//}
