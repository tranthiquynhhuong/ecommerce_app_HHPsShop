import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/models/Product.dart';
import 'package:grocery_shop_flutter/repositories/ProductsRepository.dart';
import 'package:grocery_shop_flutter/components/ProductWidget.dart';
import 'package:grocery_shop_flutter/components/MinimalCart.dart';

class GridCategoryProduct extends StatefulWidget {
  final String catID;
  final String selectedSortType;

  GridCategoryProduct(this.catID,this.selectedSortType);

  @override
  _GridCategoryProduct createState() => new _GridCategoryProduct();
}

class _GridCategoryProduct extends State<GridCategoryProduct> {
  bool isLoading = true;
  List<Product> _products = [];

  Future<List<Product>> getProducts() async {
    List<Product> _products =
        await ProductsRepository().getProductByCategory(widget.catID);
    setState(() {
      isLoading = false;
    });
    return _products;
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    print('DetailCommentHeaderState initState');
  }

  Future<Null> refeshList() async {
    await Future.delayed(Duration(seconds: 2));
    ProductsRepository().getProductByCategory(widget.catID);
    setState(() {
      _products=[];
    });
  }

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
  _buildProductGrid(double _gridSize, double childAspectRatio) {
    return FutureBuilder(
      future: getProducts(),
      initialData: List<Product>.from([]),
      builder: (context, snapshot) {
        // snapshot.data = list products theo catID
        if ((snapshot.data == null || snapshot.data.length == 0) &&
            !isLoading) {
          return Column(
            children: <Widget>[
              new Container(
                  child: Center(
                    child: Text("Hiện không có sản phẩm nào!"),
                  ),
                  height: _gridSize,
                  decoration: BoxDecoration(
                      color: const Color(0xFFeeeeee),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(_gridSize / 10),
                          bottomRight: Radius.circular(_gridSize / 10))),
                  padding: EdgeInsets.only(left: 10, right: 10))
            ],
          );
        } else {
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
                                child: GridView.builder(
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
                                              product: _products[index],
                                            onRefresh: refeshList,));
                                    }),
                                onRefresh: refeshList,
                              ),
                            ))
                      ])),
                  new MinimalCart(),
                ])),
          ]);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double _gridSize =
        MediaQuery.of(context).size.height - 100; //88% of screen
    double childAspectRatio = MediaQuery.of(context).size.width /
        (MediaQuery.of(context).size.height / 1.0);
    return _buildProductGrid(_gridSize, childAspectRatio);
  }
}
