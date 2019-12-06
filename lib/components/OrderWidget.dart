import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/models/Order.dart';
import 'package:intl/intl.dart';

class OrderWidget extends StatelessWidget {
  final Order _order;
  final double _gridSize;
  OrderWidget(this._order, this._gridSize);

  @override
  Widget build(BuildContext context) {
    final format = new NumberFormat("#,##0");

    return new Row(
//        crossAxisAlignment: CrossAxisAlignment.center,
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new ClipOval(
              child: new Container(
                  color: Colors.white,
                  child: new Image.network(this._order.product.imgURL),
                  height:
                      (MediaQuery.of(context).size.height - _gridSize) * 0.5)),

          new Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: new Container(
                width: 30,
                height: 30,
                child: Center(
                  child: new Text(this._order.quantity.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )),

          new Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: new Container(
                width: 10,
                height: 20,
                child: Center(
                  child: Text("x",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              )),

          new Flexible(
              flex: 3,
              child: new Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Container(
                    width: 200,
                    child: new Text(this._order.product.name,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ))),
          new Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: new Container(
                width: 50,
                height: 20,
                child: new Text(format.format(this._order.orderPrice).toString()+"đ",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold)),
              )),


        ]);
  }
}
