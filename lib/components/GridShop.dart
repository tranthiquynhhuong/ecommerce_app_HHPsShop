import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/models/Product.dart';
import 'package:grocery_shop_flutter/repositories/ProductsRepository.dart';
import 'package:grocery_shop_flutter/components/ProductWidget.dart';
import 'package:grocery_shop_flutter/components/MinimalCart.dart';

class GridShop extends StatefulWidget {
  final String selectedSortType;
  GridShop({this.selectedSortType});
  @override
  _GridShop createState() => new _GridShop();
}

class _GridShop extends State<GridShop> {
  List<Product> _products = [];

  sortByPrice_Decrease(List<Product> pros) {
    List<Product> sortPros = [];
    pros.sort((a, b) => b.price.compareTo(a.price));
    for (var p in pros) {
      sortPros.add(p);
    }
    return sortPros;
  }

  sortByPrice_Increase(List<Product> pros) {
    List<Product> sortPros = [];
    pros.sort((a, b) => a.price.compareTo(b.price));
    for (var p in pros) {
      sortPros.add(p);
    }
    return sortPros;
  }

  sortByDate_New(List<Product> pros) {
    List<Product> sortPros = [];
    pros.sort((a, b) => b.date.compareTo(a.date));
    for (var p in pros) {
      sortPros.add(p);
    }
    return sortPros;
  }

  sortByDate_Old(List<Product> pros) {
    List<Product> sortPros = [];
    pros.sort((a, b) => a.date.compareTo(b.date));

    for (var p in pros) {
      sortPros.add(p);
    }
    return sortPros;
  }

  Future<Null> refeshList() async {
    await Future.delayed(Duration(seconds: 2));
    ProductsRepository().fetchAllProducts();
    setState(() {
      _products=[];
    });
  }

  _buildProductGrid(double _gridSize, double childAspectRatio) {
    return FutureBuilder(
      future: ProductsRepository().fetchAllProducts(),
      builder: (context, snapshot) {
        // snapshot.data chính là list products
        if (snapshot.data == null)
          return Column(
            children: <Widget>[
              new Container(
                  height: _gridSize,
                  decoration: BoxDecoration(
                      color: const Color(0xFFeeeeee),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(_gridSize / 10),
                          bottomRight: Radius.circular(_gridSize / 10))),
                  padding: EdgeInsets.only(left: 10, right: 10))
            ],
          );
        if(widget.selectedSortType=='Giá tăng dần'){
          _products=sortByPrice_Increase(snapshot.data);
        } else if(widget.selectedSortType=='Giá giảm dần'){
          _products=sortByPrice_Decrease(snapshot.data);
        } else if(widget.selectedSortType=='Mới nhất'){
          _products=sortByDate_New(snapshot.data);
        }else if(widget.selectedSortType=='Cũ nhất'){
          _products=sortByDate_Old(snapshot.data);
        }
        else{
          _products = snapshot.data;
        }
        return new Column(children: <Widget>[
          new Container(
              height: _gridSize,
              decoration: BoxDecoration(
                  color: const Color(0xFFeeeeee),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(_gridSize / 10),
                      bottomRight: Radius.circular(_gridSize / 10))),
              padding: EdgeInsets.only(left: 10, right: 10),
              child: new Column(children: <Widget>[
                new Container(
                    margin: EdgeInsets.only(top: 0),
                    child: new Column(children: <Widget>[
                      new Container(
                          height: _gridSize - 88,
                          margin: EdgeInsets.only(top: 0),
                          child: new PhysicalModel(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.only(
                                bottomLeft:
                                    Radius.circular(_gridSize / 10 - 10),
                                bottomRight:
                                    Radius.circular(_gridSize / 10 - 10)),
                            clipBehavior: Clip.antiAlias,
                            child: RefreshIndicator(
                              child: new GridView.builder(
                                  itemCount: _products.length,
                                  gridDelegate:
                                      new SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: childAspectRatio),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return new Padding(
                                        padding: EdgeInsets.only(
                                            top: index % 2 == 0 ? 20 : 0,
                                            right: index % 2 == 0 ? 5 : 0,
                                            left: index % 2 == 1 ? 5 : 0,
                                            bottom: index % 2 == 1 ? 20 : 0),
                                        child: ProductWidget(
                                            product: _products[index]));
                                  }),
                              onRefresh: refeshList,
                            ),
                          ))
                    ])),
                new MinimalCart(_gridSize),
              ])),
          //new MinimalCart(_gridSize)
        ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double _gridSize =
        MediaQuery.of(context).size.height * 0.88; //88% of screen
    double childAspectRatio = MediaQuery.of(context).size.width /
        (MediaQuery.of(context).size.height / 0.9);
    return _buildProductGrid(_gridSize, childAspectRatio);
  }
}
