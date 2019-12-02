class FeedBack {
  String _proID;
  String _email;
  String _date;
  String _content;
  String _fbID;
  double _rating;

  FeedBack(this._proID, this._email, this._date, this._content, this._fbID,this._rating);

  String get proID => _proID;

  String get email => _email;

  String get date => _date;

  String get content => _content;

  String get fbID => _fbID;
  double get rating => _rating;

}
