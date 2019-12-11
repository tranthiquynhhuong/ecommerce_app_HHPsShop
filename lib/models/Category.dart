
class Category {
  String _imgURL;
  String _catID;
  String _name;

  Category(this._catID, this._name, this._imgURL);

  String get catID => _catID;
  String get name => _name;
  String get imgURL => _imgURL;

}
