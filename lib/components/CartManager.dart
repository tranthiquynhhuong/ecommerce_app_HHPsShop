import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/bloc/UserBloc.dart';
import 'package:grocery_shop_flutter/components/AppTools.dart';
import 'package:grocery_shop_flutter/models/Cart.dart';
import 'package:grocery_shop_flutter/bloc/CartBloc.dart';
import 'package:grocery_shop_flutter/components/OrderWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_shop_flutter/models/Order.dart';
import 'package:grocery_shop_flutter/repositories/ProductsRepository.dart';
import 'package:grocery_shop_flutter/repositories/ReceiptRepository.dart';
import 'package:grocery_shop_flutter/views/Home.dart';
import 'package:grocery_shop_flutter/views/Receipt.dart';
import 'package:intl/intl.dart';

class CartManager extends StatefulWidget {
  @override
  _CartManager createState() => new _CartManager();
}

class _CartManager extends State<CartManager> {
  CartBloc _cartBloc=new CartBloc();
  final _userBloc = UserBloc();
  TextEditingController location = new TextEditingController();
  final format = new NumberFormat("#,##0");


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _gridSize = MediaQuery.of(context).size.height * 0.88;

    return new Container(
        height: MediaQuery.of(context).size.height,
        child: new Stack(children: <Widget>[
          new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new StreamBuilder(
                    initialData: _cartBloc.currentCart,
                    stream: _cartBloc.observableCart,
                    builder: (context, AsyncSnapshot<Cart> snapshot) {
                      return new Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          height: _gridSize,
                          width: double.infinity,
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Padding(
                                    padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                                    child: new Text("Giỏ hàng",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold))),
                                new Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    height: _gridSize * 0.60,
                                    child: new ListView.builder(
                                        itemCount: snapshot.data.orders.length,
                                        itemBuilder: (context, index) {
                                          return Dismissible(
                                            background: Container(
                                                color: Colors.transparent),
                                            key: Key(snapshot
                                                .data.orders[index].id
                                                .toString()),
                                            onDismissed: (_) {
                                              _cartBloc.removerOrderOfCart(
                                                  snapshot.data.orders[index]);
                                            },
                                            child: new Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: new OrderWidget(
                                                    snapshot.data.orders[index],
                                                    _gridSize)),
                                          );
                                        })),
                                new Container(
                                    height: _gridSize * 0.15,
                                    child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          new Text("Tổng cộng",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20)),
                                          Flexible(
                                            child: Text(
                                                format.format(snapshot.data.totalPrice()).toString()+"đ",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 40)),
                                          ),
                                        ]))
                              ]));
                    }),
              ]),
          new Align(
              alignment: Alignment.bottomLeft,
              child: new Container(
                  padding: EdgeInsets.only(left: 10, bottom: _gridSize * 0.02),
                  width: MediaQuery.of(context).size.width - 80,
                  child: new RaisedButton(
                      color: Colors.amber,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60)),
                      padding: EdgeInsets.all(20),
                      onPressed: () {
                        if (_cartBloc.currentCart.isEmpty)
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text("Giỏ hàng trống")));
                        else
                          _showDialogReceipt();
                      },
                      child: new Text("Xác nhận",
                          style: TextStyle(fontWeight: FontWeight.bold)))))
        ]));
  }

  void _showDialogReceipt() {

    // flutter defined function
    showDialog(
        context: context,
        builder: (context) {
          final format = new NumberFormat("#,##0");

          return AlertDialog(
            title: Text('Xác nhận đặt hàng'),
            content: Container(
              //color: Colors.white,
              width: 550,
              height: 600,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        StreamBuilder(
                            initialData: _userBloc.userInfo,
                            stream: _userBloc.observableUser,
                            builder: (context, snapshot) {
                              return Container(
                                padding: const EdgeInsets.all(10.0),
                                color: Colors.grey.shade300,
                                height: 225,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(Icons.person),
                                        Text(" " + snapshot.data.fullname),
                                      ],
                                    ),
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.email),
                                          Flexible(
                                            child: Text(" " + snapshot.data.email),
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(Icons.phone),
                                        Text(" " + snapshot.data.phone),
                                      ],
                                    ),
                                    Container(
                                      height: 50,
                                      child: appTextField(
                                        isPassword: false,
                                        textHint: "*Địa chỉ giao",
                                        textIcon: Icons.location_on,
                                        controller: location,
                                      ),
                                    ),
                                    RaisedButton(
                                      color: Colors.amber.shade300,
                                      onPressed: () {
                                        location.text =
                                            snapshot.data.location.toString();
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.home,
                                            color: Colors.black,
                                          ),
                                          Text(
                                            "    Lấy địa chỉ của tôi",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        Divider(
                          color: Colors.red,
                        ),
                        Container(
                          child: Center(
                            child: Text(
                              "Vui lòng kiểm tra thông tin",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Divider(color: Colors.red),
                        new Container(
                          height: 160,
                          child: new ListView.builder(
                            itemCount: _cartBloc.currentCart.orders.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[

                                      Expanded(
                                        child: Container(
                                          child: Text(_cartBloc.currentCart
                                              .orders[index].product.name
                                              .toString()),
                                        ),
                                        flex: 3,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(" x "),
                                        ),
                                        flex: 1,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(_cartBloc.currentCart
                                              .orders[index].quantity
                                              .toString()),
                                        ),
                                        flex: 1,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Text(format.format(_cartBloc.currentCart
                                              .orders[index].orderPrice
                                              ).toString()+"đ"),
                                        ),
                                        flex: 2,
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                ],
                              );
                            },
                          ),
                        ),
                        Divider(
                          color: Colors.red,
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Center(
                                child: Text("TỔNG CỘNG"),
                              ),
                              Center(
                                child: Text(format.format(_cartBloc.currentCart
                                    .totalPrice())
                                    .toString()+"đ",),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.green.shade400,
                onPressed: () async {
                  if (location.text == "") {
                    Fluttertoast.showToast(
                        msg: "Vui lòng nhập địa chỉ giao hàng!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 2,
                        backgroundColor: Colors.red.shade300,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    bool resultUpdateQuantity;
                    displayProgressDialog(context);
                    List<Order> orders = [];
                    for (var o in _cartBloc.currentCart.orders) {
                      orders.add(o);
                      print(o.product.name+o.quantity.toString()+o.orderPrice.toString());
                    }

                    bool response =
                        await ReceiptRepository().createdUserReceipt(
                      deliveryAdd: location.text,
                      orders: orders,
                      totalPrice: _cartBloc.currentCart.totalPrice(),
                      totalPro: _cartBloc.currentCart.orderCount,
                      userID: _userBloc.userInfo.userID,
                          phone: int.parse(_userBloc.userInfo.phone),
                    );

                    for (var o in _cartBloc.currentCart.orders) {
                      resultUpdateQuantity = await ProductsRepository()
                          .updateQuantityAfterBuy(o.product, o.quantity);
                    }

                    if (response == true && resultUpdateQuantity == true) {
                      closeProgressDialog(context);
                      Navigator.of(context).pop();
                      _showResultDialog();
                      setState(() {
                        _cartBloc.clear();
                      });
                    } else if (response == false) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Đặt hàng thất bại!")));
                      closeProgressDialog(context);
                    }
                  }
                },
                child: Text(
                  'Đồng ý',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              FlatButton(
                color: Colors.red.shade400,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Hủy', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
  }

  void _showResultDialog() {
    // flutter defined function
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('THÔNG BÁO'),
            content: Container(
              height: 120,
              child: Column(
                children: <Widget>[
                  Text("Bạn đã đặt hàng thành công!!!"),
                  RaisedButton(
                    color: Colors.amber,
                    onPressed: () {
                      _cartBloc.dispose();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) => new ReceiptPage()));
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.receipt,
                          color: Colors.black,
                        ),
                        Text(
                          " Xem đơn hàng của tôi",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    child: Center(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.black,
                onPressed: () {
                  _cartBloc.dispose();
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => new MyHomePage()));
                },
                child: Text('Tiếp tục mua hàng >',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
  }
}
