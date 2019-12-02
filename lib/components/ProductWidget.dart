import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/components/SaleTag.dart';
import 'package:grocery_shop_flutter/models/Product.dart';
import 'package:grocery_shop_flutter/views/ProductView.dart';
import 'package:intl/intl.dart';

class ProductWidget extends StatelessWidget {
  final Product product;

  ProductWidget({Key key, this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 1.2;
    double fontSize = (height / 24).round().toDouble();

    if (product.isSale == 1) {
      return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => new ProductView(product: this.product)));
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
                      discout: this.product.discount.toString(),
                    ),
                    new Center(
                        child: new Hero(
                            tag: "tagHero${this.product.proID}",
                            child: CachedNetworkImage(
                              imageUrl: this.product.imgURL,
                              fit: BoxFit.cover,
                              height: height * 0.20,
                            ))),
//                          child: new Image.network(this.product.imgURL,
//                              fit: BoxFit.cover, height: height * 0.20))),
                    new Container(
                        height: height * 0.25,
                        margin: EdgeInsets.only(top: 10),
                        child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                  (this.product.price -
                                              (this.product.price *
                                                  this.product.discount ~/
                                                  100))
                                          .toString() +
                                      " ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: fontSize)),
                              new Text(this.product.price.toString(),
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                      fontSize: 15,
                                      decoration: TextDecoration.lineThrough)),
                              new Container(
                                  margin: EdgeInsets.only(top: 5, bottom: 5),
                                  child: new Text("${this.product.name}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: fontSize * 0.65))),
                              new Text("${this.product.volumetric}ml",
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
                                  height: 30,
                                  child: Center(
                                    child: countDown(product.endSale),
                                  ),
                                ),
                              ),
                            ]))
                  ])));
    } else {
      return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => new ProductView(product: this.product)));
          },
          child: new Container(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
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
                            tag: "tagHero${this.product.proID}",
                            child: CachedNetworkImage(
                              imageUrl: this.product.imgURL,
                              fit: BoxFit.cover,
                              height: height * 0.20,
                            ))),
//                          child: new Image.network(this.product.imgURL,
//                              fit: BoxFit.cover, height: height * 0.20))),
                    new Container(
                        height: height * 0.25,
                        margin: EdgeInsets.only(top: 10),
                        child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(this.product.price.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: fontSize)),
                              new Container(
                                  margin: EdgeInsets.only(top: 20, bottom: 10),
                                  child: new Text("${this.product.name}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: fontSize * 0.65))),
                              new Text("${this.product.volumetric}ml",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: fontSize * 0.48))
                            ]))
                  ])));
    }
  }
}

Widget countDown(String endTime) {
  int _endTime = DateTime.parse(endTime).toLocal().millisecondsSinceEpoch;
  return StreamBuilder(
      stream: Stream.periodic(Duration(seconds: 1), (i) => i),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        int now = DateTime.now().millisecondsSinceEpoch;
        Duration remaining = Duration(milliseconds: _endTime - now);
        int hour = remaining.inHours - remaining.inDays * 24;
        int minute = remaining.inMinutes - remaining.inHours * 60;
        int second = remaining.inSeconds - remaining.inMinutes * 60;
        var dateString = 'Còn ${remaining.inDays} ngày $hour:$minute:$second';
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
                  colors: [Colors.greenAccent.withOpacity(0.3),Colors.green],
                  begin: Alignment.centerRight,
                  end: new Alignment(-1.0, -1.0)),
          ),
          //color: Colors.greenAccent.withOpacity(0.3),
          alignment: Alignment.center,
          child: Text(dateString),
        );
      });
}
