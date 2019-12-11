import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/bloc/FavoriteBloc.dart';
import 'package:grocery_shop_flutter/bloc/UserBloc.dart';
import 'package:grocery_shop_flutter/components/FavoriteWidget.dart';
import 'package:grocery_shop_flutter/models/Favorite.dart';
import 'package:grocery_shop_flutter/models/Product.dart';
import 'package:grocery_shop_flutter/repositories/ProductsRepository.dart';
import 'package:grocery_shop_flutter/views/Home.dart';
import 'package:grocery_shop_flutter/views/ProductView.dart';
import 'Search.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with AutomaticKeepAliveClientMixin<FavoritePage> {
  final _favoriteBloc = new FavoriteBloc();
  final _userBloc = new UserBloc();
  bool isLoading = true;
  List<Favorite> _lstSortFavorite = [];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _favoriteBloc.fetchFavorites(_userBloc.userInfo.userID).then((var a) {
      setState(() {
        isLoading = false;
      });
    });
    // TODO: implement initState
    super.initState();
    print('DetailCommentHeaderState initState');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("DetailCommentListHeader dispose");
  }

  sortByDate(List<Favorite> favors) {
    List<Favorite> sortFavors = [];
    favors.sort((a, b) => b.date.compareTo(a.date));
    for (var r in favors) {
      sortFavors.add(r);
    }
    return sortFavors;
  }

  Future<Null> refeshList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _favoriteBloc.fetchFavorites(_userBloc.userInfo.userID).then((var a) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Row(
          children: <Widget>[
            Text("Yêu thích ",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            Icon(
              Icons.favorite,
              color: Colors.red,
              size: 30,
            ),
          ],
        ),
        leading: new IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).push(
                new MaterialPageRoute(builder: (context) => new MyHomePage()));
          },
        ),
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new SearchPage()));
              })
        ],
      ),
      body: StreamBuilder(
          initialData: _favoriteBloc.favorites,
          stream: _favoriteBloc.observableFavor,
          builder: (context, snapshot) {
            if ((snapshot.data == null || snapshot.data.length == 0) &&
                !isLoading)
              return Container(
                child: Center(
                  child: Text("Hiện không có sản phẩm yêu thích nào!"),
                ),
              );
            List<Favorite> _favorites = snapshot.data;
            _lstSortFavorite = sortByDate(_favorites);

            return RefreshIndicator(
              child: ListView.builder(
                itemCount: _lstSortFavorite.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () async {
                      Product pro = await ProductsRepository()
                          .getProductByProID(_lstSortFavorite[index].proID);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductView(
                              product: pro,
                            ),
                          ));
                    },
                    child: FavoriteWidget(
                      favorite: _lstSortFavorite[index],
                    ),
                  );
                },
              ),
              onRefresh: refeshList,
            );
          }),
    );
  }
}
