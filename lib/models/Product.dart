class Product {
  String _proID;
  String _catID;
  String _name;
  String _description;
  String _imgURL;
  int _price;
  int _volumetric;
  int _quantity;
  int _isSale;
  int _discount;
  String _startSale;
  String _endSale;
  String _date;

  Product(
      this._proID,
      this._catID,
      this._name,
      this._description,
      this._imgURL,
      this._price,
      this._volumetric,
      this._quantity,
      this._isSale,
      this._discount,
      this._startSale,
      this._endSale,
      this._date);

  String get proID => _proID;
  String get catID => _catID;
  String get name => _name;
  String get description => _description;
  String get imgURL => _imgURL;
  int get price => _price;
  int get volumetric => _volumetric;
  int get quantity => _quantity;
  int get isSale => _isSale;
  int get discount => _discount;
  String get startSale => _startSale;
  String get endSale => _endSale;
  String get date => _date;

}
