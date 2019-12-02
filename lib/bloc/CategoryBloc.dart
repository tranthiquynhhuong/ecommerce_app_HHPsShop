import 'package:grocery_shop_flutter/models/Category.dart';
import 'package:grocery_shop_flutter/repositories/CategoryRepository.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc {
  final _cateRepo = CategoryRepository();
  static CategoryBloc _categoryBloc;

  PublishSubject<List<Category>> _publishSubjectCate;
  List<Category> _categories = [];
  List<Category> get categories => _categories;

  factory CategoryBloc() {
    if (_categoryBloc == null) _categoryBloc = new CategoryBloc._();

    return _categoryBloc;
  }

  CategoryBloc._() {
    _publishSubjectCate = new PublishSubject<List<Category>>();
  }

  Observable<List<Category>> get observableCate => _publishSubjectCate.stream;

  Future fetchCates() async {
    try {
      List<Category> _res = await _cateRepo.fetchAllCategories();
      _categories = _res;
      _updateCate();
    } catch (e) {
      print(e);
    }
  }

  void _updateCate() {
    _publishSubjectCate.sink.add(_categories);
  }

  dispose() {
    _categoryBloc = null;
    _publishSubjectCate.close();
  }
}
