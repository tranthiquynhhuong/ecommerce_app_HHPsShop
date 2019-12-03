import 'package:grocery_shop_flutter/models/Favorite.dart';
import 'package:grocery_shop_flutter/repositories/FavoriteRepository.dart';
import 'package:rxdart/rxdart.dart';

class FavoriteBloc {
  final _favorRepo = FavoriteRepository();
  static FavoriteBloc _favoriteBloc;

  PublishSubject<List<Favorite>> _publishSubjectFavorite;
  List<Favorite> _favorites = [];
  List<Favorite> get favorites => _favorites;

  factory FavoriteBloc() {
    if (_favoriteBloc == null) _favoriteBloc = new FavoriteBloc._();

    return _favoriteBloc;
  }

  FavoriteBloc._() {
    _publishSubjectFavorite = new PublishSubject<List<Favorite>>();
  }

  Observable<List<Favorite>> get observableFavor =>
      _publishSubjectFavorite.stream;

  Future fetchFavorites(String userID) async {
    try {
      List<Favorite> _res = await _favorRepo.getFavoriteOfUser(userID);
      _favorites = _res;
      _updateFavorite();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> createFavorite(String userID, String proID) async {
    try {
      var response = await _favorRepo.createFavorite(proID, userID);
      if (response != null) {
        _updateFavorite();
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteFavorite(String favorID) async {
    try {
      var response = await _favorRepo.deleteFavorite(favorID);
      if (response != null) {
        _updateFavorite();
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  void _updateFavorite() {
    _publishSubjectFavorite.sink.add(_favorites);
  }

  dispose() {
    _favoriteBloc = null;
    _publishSubjectFavorite.close();
  }
}
