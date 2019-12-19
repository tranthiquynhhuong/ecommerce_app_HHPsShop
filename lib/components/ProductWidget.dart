import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/bloc/ProductBloc.dart';
import 'package:grocery_shop_flutter/components/SaleTag.dart';
import 'package:grocery_shop_flutter/models/Product.dart';
import 'package:grocery_shop_flutter/views/ProductView.dart';
import 'package:intl/intl.dart';

class ProductWidget extends StatefulWidget {
  final Product product;
  final Function onRefresh;
  ProductWidget({Key key, this.product, this.onRefresh}) : super(key: key);

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  final _proBloc = new ProductBloc();
  Product product;

  @override
  void initState() {
    _proBloc.getProductByID(widget.product.proID);
    // TODO: implement initState
    super.initState();
  }

  Future<Null> refesh() async {
    await Future.delayed(Duration(seconds: 2));
    Product _product = await _proBloc.getProductByID(widget.product.proID);
    setState(() {
      product = _product;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 1.2;
    double fontSize = (height / 24).round().toDouble();
    final format = new NumberFormat("#,##0");
    product = widget.product;

    if (product.isSale == 1) {
      return GestureDetector(
          onTap: () async {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => new ProductView(
                      product: widget.product,
                    )));
          },
          child: new Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 13.0,
                      color: Colors.black.withOpacity(.5),
                      offset: Offset(6.0, 7.0),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: new Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new SaleTag(
                      discout: widget.product.discount.toString(),
                    ),
                    new Center(
                        child: new Hero(
                            tag: "tagHero${widget.product.proID}",
                            child: CachedNetworkImage(
                              imageUrl: widget.product.imgURL,
                              fit: BoxFit.cover,
                              height: height * 0.20,
                            ))),
                    new Container(
                        height: height * 0.25,
                        margin: EdgeInsets.only(top: 10),
                        child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                  (format
                                          .format(widget.product.price -
                                              (widget.product.price *
                                                  widget.product.discount ~/
                                                  100))
                                          .toString()) +
                                      "đ ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: fontSize)),
                              new Text(
                                  format
                                          .format(widget.product.price)
                                          .toString() +
                                      "đ",
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                      fontSize: 15,
                                      decoration: TextDecoration.lineThrough)),
                              new Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 5),
                                  child: new Text("${widget.product.name}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: fontSize * 0.65))),
                              new Text("${widget.product.volumetric}ml",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: fontSize * 0.48)),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: new Container(
                                  decoration: new BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  width: 400,
                                  height: 35,
                                  child: Center(
                                    child: countDownEndSale(
                                        widget.product.endSale),
                                  ),
                                ),
                              ),
                            ]))
                  ])));
    } else {
      return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    new ProductView(product: widget.product)));
          },
          child: new Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 13.0,
                      color: Colors.black.withOpacity(.5),
                      offset: Offset(6.0, 7.0),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: new Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Center(
                        child: new Hero(
                            tag: "tagHero${widget.product.proID}",
                            child: CachedNetworkImage(
                              imageUrl: widget.product.imgURL,
                              fit: BoxFit.cover,
                              height: height * 0.20,
                            ))),
                    new Container(
                        height: height * 0.25,
                        margin: EdgeInsets.only(top: 10),
                        child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                  format
                                          .format(widget.product.price)
                                          .toString() +
                                      "đ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: fontSize)),
                              new Container(
                                  margin: EdgeInsets.only(top: 20, bottom: 10),
                                  child: new Text("${widget.product.name}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: fontSize * 0.65))),
                              new Text("${widget.product.volumetric}ml",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: fontSize * 0.48)),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: new Container(
                                  decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  width: 400,
                                  height: 35,
                                  child: Center(
                                    child: countDownStartSale(
                                        widget.product.startSale),
                                  ),
                                ),
                              ),
                            ]))
                  ])));
    }
  }

  Widget countDownEndSale(String endTime) {
    try {
      int _endTime = DateTime.parse(endTime).toUtc().millisecondsSinceEpoch;
      return StreamBuilder(
          stream: Stream.periodic(Duration(seconds: 1), (i) => i),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            int now = DateTime.now().toUtc().millisecondsSinceEpoch;
            Duration remaining = Duration(milliseconds: _endTime - now);
            int hour = remaining.inHours - remaining.inDays * 24;
            int minute = remaining.inMinutes - remaining.inHours * 60;
            int second = remaining.inSeconds - remaining.inMinutes * 60;
            var dateString =
                'Còn ${remaining.inDays} ngày $hour:$minute:$second';

            if (remaining.inSeconds == 0 || remaining.inSeconds < 0) {
              widget.onRefresh();
              return Container(
                color: Colors.white,
              );
            }
            return Container(
              decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 13.0,
                    color: Colors.grey.withOpacity(.5),
                    offset: Offset(6.0, 7.0),
                  ),
                ],
                gradient: new LinearGradient(
                    colors: [Colors.greenAccent.withOpacity(0.3), Colors.green],
                    begin: Alignment.centerRight,
                    end: new Alignment(-1.0, -1.0)),
              ),
              //color: Colors.greenAccent.withOpacity(0.3),
              alignment: Alignment.center,
              child: Text(dateString,style: TextStyle(fontSize: 13)),
            );
          });
    } catch (e) {}
  }

  Widget countDownStartSale(String startTime) {
    try {
      int _startTime = DateTime.parse(startTime).toUtc().millisecondsSinceEpoch;
      return StreamBuilder(
          stream: Stream.periodic(Duration(seconds: 1), (i) => i),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            int now = DateTime.now().toUtc().millisecondsSinceEpoch;
            Duration remaining = Duration(milliseconds: _startTime - now);
            int hour = remaining.inHours - remaining.inDays * 24;
            int minute = remaining.inMinutes - remaining.inHours * 60;
            int second = remaining.inSeconds - remaining.inMinutes * 60;
            var dateString = '${remaining.inDays} ngày $hour:$minute:$second nữa';

            if (remaining.inSeconds == 0 || remaining.inSeconds < 0) {
              widget.onRefresh();
              return Container(
                color: Colors.white,
              );
            } else
              return Container(
                decoration: new BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 13.0,
                      color: Colors.grey.withOpacity(.5),
                      offset: Offset(6.0, 7.0),
                    ),
                  ],
                  gradient: new LinearGradient(
                      colors: [
                        Colors.orangeAccent.withOpacity(0.3),
                        Colors.deepOrange
                      ],
                      begin: Alignment.centerRight,
                      end: new Alignment(-1.0, -1.0)),
                ),
                //color: Colors.greenAccent.withOpacity(0.3),
                alignment: Alignment.center,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text("Khuyến mãi "+widget.product.discount.toString()+"% sau"),
                      Text(dateString,style: TextStyle(fontSize: 13),),
                    ],
                  ),
                )
              );
          });
    } catch (e) {
    }
  }
}
