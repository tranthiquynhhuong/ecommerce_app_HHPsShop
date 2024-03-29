import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/bloc/FavoriteBloc.dart';
import 'package:grocery_shop_flutter/components/AppTools.dart';
import 'package:grocery_shop_flutter/models/Favorite.dart';
import 'package:grocery_shop_flutter/models/Product.dart';
import 'package:grocery_shop_flutter/repositories/FavoriteRepository.dart';
import 'package:grocery_shop_flutter/repositories/ProductsRepository.dart';
import 'package:intl/intl.dart';

class FavoriteWidget extends StatefulWidget {
  final Favorite favorite;
  FavoriteWidget({this.favorite});

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  Product product;
  final _favorBloc = FavoriteBloc();
  final format = new NumberFormat("#,##0");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ProductsRepository().getProductByProID(widget.favorite.proID),
      builder: (context, snapshot) {
        Product pro = snapshot.data;
        if (snapshot.data == null) {
          return Container();
        }
        return _buildProductFavorite(pro);
      },
    );
  }

  Widget _buildProductFavorite(Product pro) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            ClipOval(
                child: new Container(
              color: Colors.white,
              child: new Image.network(pro.imgURL),
              height: 50,
              width: 50,
            )),
            Flexible(
                child: ListTile(
              title: Text(
                pro.name.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              subtitle: pro.isSale == 1
                  ? Row(
                      children: <Widget>[
                         Text(
                            format.format((pro.price - (pro.price * pro.discount ~/ 100)))
                                    .toString() +
                                "đ ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 15)),
                        Text(format.format(pro.price).toString()+"đ ",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                                fontSize: 13,
                                decoration: TextDecoration.lineThrough)),
                        Container(
                          decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20))),
                          width: 40,
                          height: 20,
                          child: Center(
                            child: Text(
                              "-" +
                                  pro.discount.toString() +
                                  "%",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                      ],
                    )
                  : Row(
                      children: <Widget>[
                        new Text(format.format(pro.price).toString()+"đ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 15)),
                      ],
                    ),
              trailing: IconButton(
                onPressed: () async {
                  displayProgressDialog(context);
                  bool response = await FavoriteRepository()
                      .deleteFavorite(widget.favorite.userID,widget.favorite.proID);
                  if (response) {
                    setState(() async {
                      await _favorBloc.countFavoriteByProID(widget.favorite.proID);
                      await FavoriteBloc().fetchFavorites(widget.favorite.userID);
                      closeProgressDialog(context);
                    });
                  } else
                    (print("Khong xoa favorite duoc"));
                },
                icon: Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
              ),
            )),
          ],
        ),
        Divider(
          color: Colors.amber,
          thickness: 1,
        ),
      ],
    );
  }
}
