import 'package:grocery_shop_flutter/models/Product.dart';
import 'package:grocery_shop_flutter/repositories/ProductsRepository.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc {
  final _proRepo = ProductsRepository();
  static ProductBloc _productBloc;

  PublishSubject<Product> _publishSubjectProduct;
  Product _product;
  Product get product => _product;

  factory ProductBloc() {
    if (_productBloc == null) _productBloc = new ProductBloc._();

    return _productBloc;
  }

  ProductBloc._() {
    _publishSubjectProduct = new PublishSubject<Product>();
  }

  Observable<Product> get observableProduct => _publishSubjectProduct.stream;

  Future<Product> getProductByID(String proID) async {
    try {
      _product = await _proRepo.getProductByProID(proID);
      if (_product != null) {
        _updateProduct();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> increaseFavoriteCount(Product product)async{
    try {
      bool response = await _proRepo.increaseFavoriteCount(product);
      _updateProduct();
      if (response==false) {
       return false;
      }
      return true;
    } catch (e) {
      print("Err increaseFavoriteCount ====> "+e);
      return false;
    }
  }

  Future<bool> decreaseFavoriteCount(Product product)async{
    try {
      bool response = await _proRepo.decreaseFavoriteCount(product);
      _updateProduct();
      if (response==false) {
        return false;
      }
      return true;
    } catch (e) {
      print("Errr decreaseFavoriteCount ====> "+e);
      return false;
    }
  }


  void _updateProduct() {
    _publishSubjectProduct.sink.add(_product);
  }

  dispose() {
    _productBloc = null;
    _publishSubjectProduct.close();
  }
}
