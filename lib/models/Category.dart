
class Category {
  String _imgURL;
  String _catID;
  String _name;
  int _isActive;

  Category(this._catID, this._name, this._imgURL,this._isActive);

  String get catID => _catID;
  String get name => _name;
  String get imgURL => _imgURL;
  int get isActive => _isActive;


}
