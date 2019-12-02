class Favorite {
  String _favoriteID;
  String _proID;
  String _userID;
  String _date;

  Favorite(this._favoriteID, this._proID, this._userID, this._date);

  String get proID => _proID;
  String get userID => _userID;
  String get date => _date;
  String get favoriteID => _favoriteID;
}
