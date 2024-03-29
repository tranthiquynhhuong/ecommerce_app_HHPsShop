import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/bloc/FavoriteBloc.dart';
import 'package:grocery_shop_flutter/bloc/ProductBloc.dart';
import 'package:grocery_shop_flutter/bloc/UserBloc.dart';
import 'package:grocery_shop_flutter/models/Product.dart';
import 'package:grocery_shop_flutter/bloc/CartBloc.dart';
import 'package:grocery_shop_flutter/models/Order.dart';
import 'package:grocery_shop_flutter/views/FeedBack.dart';
import 'package:grocery_shop_flutter/views/Home.dart';
import 'package:intl/intl.dart';

class ProductView extends StatefulWidget {
  final Product product;
  ProductView({Key key, this.product}) : super(key: key);

  @override
  _ProductView createState() => new _ProductView();
}

class _ProductView extends State<ProductView> with AfterLayoutMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _electiveQuantity = new TextEditingController();
  final CartBloc _cartBloc = new CartBloc();
  final FavoriteBloc _favoriteBloc = new FavoriteBloc();
  final UserBloc _userBloc = new UserBloc();
  final ProductBloc _productBloc = new ProductBloc();
  final format = new NumberFormat("#,##0");

  int _quantity = 1;
  bool alreadySaved;
  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout
    _productBloc.getProductByID(widget.product.proID);
  }

  @override
  void initState() {
    //    // TODO: implement initState
    super.initState();
  }

  void _increment() {
    if (_quantity < _productBloc.product.quantity) {
      setState(() {
        _quantity++;
      });
    }
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _showQuantityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Vui lòng nhập số lượng muốn mua!"),
          content: TextField(
            autofocus: true,
            keyboardType: TextInputType.number,
            controller: _electiveQuantity,
            decoration: new InputDecoration(
                hintText: _productBloc.product.quantity.toString()),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
                color: Colors.green,
                child: new Text("Xong", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  int maxQuantity = _productBloc.product.quantity;
                  _quantity = int.parse(_electiveQuantity.text);
                  if (_quantity > maxQuantity || _quantity == maxQuantity) {
                    setState(() {
                      _quantity = maxQuantity;
                    });
                  } else if (_electiveQuantity.text != "" &&
                      _quantity < maxQuantity &&
                      _quantity > 0) {
                    setState(() {
                      _quantity = _quantity;
                    });
                  } else if (_electiveQuantity.text == "0") {
                    setState(() {
                      //_quantity = 1;
                    });
                  } else {
                    _quantity = 1;
                  }
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }
  void _showEmptyQuantityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("THÔNG BÁO"),
          content: Text("Sản phẩm bạn đặt vừa hết hàng, vui lòng chọn mua sản phẩm khác !!!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
                color: Colors.green,
                child: new Text("OK", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: _productBloc.product,
        stream: _productBloc.observableProduct,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          Product product = snapshot.data;
          if (product.isSale == 1) {
            return new Scaffold(
                key: _scaffoldKey,
                resizeToAvoidBottomPadding: false,
                backgroundColor: Colors.white,
                appBar: new AppBar(
                  title: Center(
                    child: Text(
                      widget.product.name,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                    ),
                  ),
                  backgroundColor: Colors.amber,
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.black),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FutureBuilder(
                        future: _favoriteBloc.checkIsFavorite(
                            _userBloc.userInfo.userID, widget.product.proID),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return Container();
                          }
                          alreadySaved = snapshot.data;
                          return IconButton(
                              icon: Icon(
                                alreadySaved
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: alreadySaved ? Colors.red : null,
                                size: 30,
                              ),
                              onPressed: () async {
                                if (alreadySaved == true) {
                                  await _favoriteBloc.deleteFavorite(
                                      _userBloc.userInfo.userID,
                                      widget.product.proID);
                                  setState(() {
                                    _favoriteBloc.countFavoriteByProID(
                                        widget.product.proID);
                                    _productBloc.product;
                                    _favoriteBloc.checkIsFavorite(
                                        _userBloc.userInfo.userID,
                                        widget.product.proID);
                                  });
                                } else if (alreadySaved == false) {
                                  await _favoriteBloc.createFavorite(
                                      _userBloc.userInfo.userID,
                                      widget.product.proID);
                                  setState(() {
                                    _favoriteBloc.countFavoriteByProID(
                                        widget.product.proID);
                                    _productBloc.product;
                                    _favoriteBloc.checkIsFavorite(
                                        _userBloc.userInfo.userID,
                                        widget.product.proID);
                                  });
                                }
                              });
                        },
                      ),
                    ),
                  ],
                ),
                body: new SafeArea(
                    child: new Column(children: <Widget>[
                  new Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: MediaQuery.of(context).size.height * 0.73,
                      child: new SingleChildScrollView(
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                            new Center(
                                child: new StreamBuilder(
                                    initialData: null,
                                    stream: _cartBloc.observableLastOrder,
                                    builder: (context,
                                        AsyncSnapshot<Order> snapshot) {
                                      String tag = snapshot.data == null
                                          ? "tagHero${product.proID}"
                                          : "tagHeroOrder${snapshot.data.id}";
                                      return new Hero(
                                          tag: tag,
                                          child: new Image.network(
                                              product.imgURL,
                                              fit: BoxFit.cover,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.4));
                                    })),
                            new Container(
                              margin: EdgeInsets.only(top: 20),
                              child: new Text(product.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                      color: Colors.black)),
                            ),
                            new Container(
                              margin: EdgeInsets.only(top: 10),
                              child: new Text("${product.volumetric}ml",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.grey)),
                            ),
                            new Container(
                                margin: EdgeInsets.only(top: 20),
                                child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: new Row(children: <Widget>[
                                          new InkWell(
                                            child: new Icon(
                                              Icons.remove,
                                              size: 15,
                                              color: Colors.black,
                                            ),
                                            onTap: _decrement,
                                          ),
                                          new InkWell(
                                            child: new Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                child: Center(
                                                  child: _quantity ==
                                                              product
                                                                  .quantity ||
                                                          _quantity <
                                                              product
                                                                  .quantity
                                                      ? new Text(
                                                          _quantity.toString(),
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.black),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          softWrap: true,
                                                        )
                                                      : new Text(
                                                          product.quantity
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.black),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          softWrap: true,
                                                        ),
                                                ),
                                              ),
                                            ),
                                            onTap: _showQuantityDialog,
                                          ),
                                          new InkWell(
                                            child: new Icon(
                                              Icons.add,
                                              size: 15,
                                              color: Colors.black,
                                            ),
                                            onTap: _increment,
                                          ),
                                        ]),
                                      ),
                                      Container(
                                        decoration: new BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        width: 50,
                                        height: 30,
                                        child: Center(
                                          child: Text(
                                            "-" +
                                                product.discount
                                                    .toString() +
                                                "%",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                          child: _quantity ==
                                                      product.quantity ||
                                                  _quantity <
                                                      product.quantity
                                              ? new Text(format.format((product.price - (product.price * product.discount ~/ 100)) * _quantity).toString() + "đ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 28,
                                                      color: Colors.black))
                                              : Text(
                                                  format
                                                          .format((product.price - (product.price * product.discount ~/ 100)) *
                                                              product
                                                                  .quantity)
                                                          .toString() +
                                                      "đ",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 28,
                                                      color: Colors.black)))
                                    ])),
                            new Container(
                                margin: EdgeInsets.only(top: 40, bottom: 40),
                                child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Text("Mô tả:",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                      new Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: new Text(
                                              product.description,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18)))
                                    ]))
                          ]))),
                  new Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius:
                            30.0, // has the effect of softening the shadow
                        spreadRadius:
                            5.0, // has the effect of extending the shadow
                        offset: Offset(
                          0.0, // horizontal, move right 10
                          -20.0, // vertical, move down 10
                        ),
                      )
                    ]),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new FlatButton.icon(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(new MaterialPageRoute(
                                        builder: (context) => new FeedBackPage(
                                              product: widget.product,
                                            )));
                              },
                              icon: new Icon(Icons.comment, color: Colors.blue),
                              label: new Text("")),
// Check số lượng Product != 0?
                          product.quantity != 0
                              ? SizedBox(
                              width:
                              MediaQuery.of(context).size.width * 0.6,
                              child: new RaisedButton(
                                  color: Colors.amber,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(60)),
                                  padding: EdgeInsets.all(20),
                                  onPressed: () async {
                                    await _productBloc.getProductByID(
                                        widget.product.proID);
                                    if (_productBloc.product.quantity ==
                                        0) {
                                      setState(() {
                                        _productBloc.getProductByID(
                                            widget.product.proID);
                                        _showEmptyQuantityDialog();
                                      });
                                    } else if (_quantity <
                                        _productBloc
                                            .product.quantity ||
                                        _quantity ==
                                            _productBloc
                                                .product.quantity) {
                                      _cartBloc.addOrderToCart(
                                          widget.product, _quantity);
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                              new MyHomePage()));
                                    } else {
                                      setState(() {
                                        _quantity = 1;
                                      });
                                    }
                                  },
                                  child: new Text("Thêm vào giỏ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))))
                              : SizedBox(
                              width:
                              MediaQuery.of(context).size.width * 0.6,
                              child: new RaisedButton(
                                  color: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(60)),
                                  padding: EdgeInsets.all(20),
                                  onPressed: () {},
                                  child: new Text("Hết hàng",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))))
                        ]),
                  )
                ])));
          } else {
            return new Scaffold(
                resizeToAvoidBottomPadding: false,
                backgroundColor: Colors.white,
                appBar: new AppBar(
                  title: Center(
                    child: Text(
                      product.name,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                    ),
                  ),
                  backgroundColor: Colors.amber,
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.black),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FutureBuilder(
                        future: _favoriteBloc.checkIsFavorite(
                            _userBloc.userInfo.userID, widget.product.proID),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return Container();
                          }
                          alreadySaved = snapshot.data;
                          return IconButton(
                              icon: Icon(
                                alreadySaved
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: alreadySaved ? Colors.red : null,
                                size: 30,
                              ),
                              onPressed: () async {
                                if (alreadySaved == true) {
                                  await _favoriteBloc.deleteFavorite(
                                      _userBloc.userInfo.userID,
                                      widget.product.proID);
                                  setState(() {
                                    _favoriteBloc.countFavoriteByProID(
                                        widget.product.proID);
                                    _productBloc.product;
                                    _favoriteBloc.checkIsFavorite(
                                        _userBloc.userInfo.userID,
                                        widget.product.proID);
                                  });
                                } else if (alreadySaved == false) {
                                  await _favoriteBloc.createFavorite(
                                      _userBloc.userInfo.userID,
                                      widget.product.proID);
                                  setState(() {
                                    _favoriteBloc.countFavoriteByProID(
                                        widget.product.proID);
                                    _productBloc.product;
                                    _favoriteBloc.checkIsFavorite(
                                        _userBloc.userInfo.userID,
                                        widget.product.proID);
                                  });
                                }
                              });
                        },
                      ),
                    ),
                  ],
                ),
                body: new SafeArea(
                    child: new Column(children: <Widget>[
                  new Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: MediaQuery.of(context).size.height * 0.73,
                      child: new SingleChildScrollView(
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                            new Center(
                                child: new StreamBuilder(
                                    initialData: null,
                                    stream: _cartBloc.observableLastOrder,
                                    builder: (context,
                                        AsyncSnapshot<Order> snapshot) {
                                      String tag = snapshot.data == null
                                          ? "tagHero${product.proID}"
                                          : "tagHeroOrder${snapshot.data.id}";
                                      return new Hero(
                                          tag: tag,
                                          child: new Image.network(
                                              product.imgURL,
                                              fit: BoxFit.cover,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.4));
                                    })),
                            new Container(
                              margin: EdgeInsets.only(top: 20),
                              child: new Text(product.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                      color: Colors.black)),
                            ),
                            new Container(
                              margin: EdgeInsets.only(top: 10),
                              child: new Text("${product.volumetric}ml",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.grey)),
                            ),
                            new Container(
                                margin: EdgeInsets.only(top: 20),
                                child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: new Row(children: <Widget>[
                                          new InkWell(
                                            child: new Icon(
                                              Icons.remove,
                                              size: 15,
                                              color: Colors.black,
                                            ),
                                            onTap: _decrement,
                                          ),
                                          new InkWell(
                                            child: new Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                child: Center(
                                                  child: (_quantity ==
                                                              product
                                                                  .quantity ||
                                                          _quantity <
                                                              product.quantity)
                                                      ? new Text(
                                                          _quantity.toString(),
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.black),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          softWrap: true,
                                                        )
                                                      : new Text(
                                                          product.quantity
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.black),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          softWrap: true,
                                                        ),
                                                ),
                                              ),
                                            ),
                                            onTap: _showQuantityDialog,
                                          ),
                                          new InkWell(
                                            child: new Icon(
                                              Icons.add,
                                              size: 15,
                                              color: Colors.black,
                                            ),
                                            onTap: _increment,
                                          ),
                                        ]),
                                      ),
                                      Flexible(
                                          child: _quantity == product.quantity ||
                                                  _quantity < product.quantity
                                              ? new Text(
                                                  format
                                                          .format(
                                                              product.price *
                                                                  _quantity)
                                                          .toString() +
                                                      "đ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 28,
                                                      color: Colors.black))
                                              : Text(
                                                  format
                                                          .format(product
                                                                  .price *
                                                              product.quantity)
                                                          .toString() +
                                                      "đ",
                                                  style:
                                                      TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 28,
                                                          color: Colors.black)))
                                    ])),
                            new Container(
                                margin: EdgeInsets.only(top: 40, bottom: 40),
                                child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Text("Mô tả:",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                      new Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: new Text(product.description,
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18)))
                                    ]))
                          ]))),
                  new Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius:
                              30.0, // has the effect of softening the shadow
                          spreadRadius:
                              5.0, // has the effect of extending the shadow
                          offset: Offset(
                            0.0, // horizontal, move right 10
                            -20.0, // vertical, move down 10
                          ),
                        )
                      ]),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new FlatButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new FeedBackPage(
                                                product: widget.product,
                                              )));
                                },
                                icon:
                                    new Icon(Icons.comment, color: Colors.blue),
                                label: new Text("")),
// Check số lượng Product != 0?
                            product.quantity != 0
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: new RaisedButton(
                                        color: Colors.amber,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60)),
                                        padding: EdgeInsets.all(20),
                                        onPressed: () async {
                                          await _productBloc.getProductByID(
                                              widget.product.proID);
                                          if (_productBloc.product.quantity ==
                                              0) {
                                            setState(() {
                                              _showEmptyQuantityDialog();
                                              _productBloc.getProductByID(
                                                  widget.product.proID);
                                            });
                                          } else if (_quantity <
                                                  _productBloc
                                                      .product.quantity ||
                                              _quantity ==
                                                  _productBloc
                                                      .product.quantity) {
                                            _cartBloc.addOrderToCart(
                                                widget.product, _quantity);
                                            Navigator.of(context).push(
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        new MyHomePage()));
                                          } else {
                                            setState(() {
                                              _quantity = 1;
                                            });
                                          }
                                        },
                                        child: new Text("Thêm vào giỏ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))))
                                : SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: new RaisedButton(
                                        color: Colors.grey,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60)),
                                        padding: EdgeInsets.all(20),
                                        onPressed: () {},
                                        child: new Text("Hết hàng",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))))
                          ]))
                ])));
          }
        });
  }
}
