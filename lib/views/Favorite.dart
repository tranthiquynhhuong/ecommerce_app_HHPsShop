import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/bloc/CategoryBloc.dart';
import 'package:grocery_shop_flutter/bloc/FavoriteBloc.dart';
import 'package:grocery_shop_flutter/bloc/UserBloc.dart';
import 'package:grocery_shop_flutter/models/Category.dart';
import 'package:grocery_shop_flutter/models/Favorite.dart';
import 'package:grocery_shop_flutter/models/Product.dart';
import 'package:grocery_shop_flutter/repositories/ProductsRepository.dart';
import 'package:grocery_shop_flutter/views/Home.dart';
import 'package:grocery_shop_flutter/views/ProductView.dart';
import 'Category.dart';
import 'Search.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>  with AutomaticKeepAliveClientMixin<FavoritePage>{
  ScrollController _scrollController = new ScrollController();
  final _favoriteBloc = new FavoriteBloc();
  final _userBloc = new UserBloc();


  bool isLoading = true;

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
                style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            Icon(Icons.favorite,color: Colors.red,size: 30,),
          ],
        ),
        leading: new IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new MyHomePage()));
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
            if (snapshot.data == null)
              return Container(
                height: 300,
              );
            List<Favorite> _favorites = snapshot.data;
            return RefreshIndicator(
              child: ListView.builder(
                itemCount: _favorites.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () async {
                      Product pro = await ProductsRepository().getProductByProID(_favorites[index].proID);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductView(product: pro,),
                          ));
                    },
                    child: Row(
                      children: <Widget>[
                        ListTile(
                          title: Row(
                            children: <Widget>[
                              Text(
                                _favorites[index].name.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                width: 30,
                                height: 30,
                                child: Image.network(
                                    _categories[index].imgURL.toString()),
                              ),
                            ],
                          ),
                          trailing: Text(
                            ">",
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              onRefresh: refeshList,
            );
          }
      ),);
  }
}
