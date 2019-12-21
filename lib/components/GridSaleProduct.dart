import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/models/Product.dart';
import 'package:grocery_shop_flutter/repositories/ProductsRepository.dart';
import 'package:grocery_shop_flutter/components/ProductWidget.dart';
import 'package:grocery_shop_flutter/components/MinimalCart.dart';

class GridSaleProduct extends StatefulWidget {
  final String selectedSortType;
  GridSaleProduct({this.selectedSortType});
  @override
  _GridSaleProduct createState() => new _GridSaleProduct();
}

class _GridSaleProduct extends State<GridSaleProduct> {
  List<Product> _productsSale = [];
  bool isLoading = true;


  Future<List<Product>> getProductsSale() async {
    List<Product> _productsSale = await ProductsRepository().getProductSale();
    setState(() {
      isLoading = false;
    });
    return _productsSale;
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    print('DetailCommentHeaderState initState');
  }

  Future<Null> refeshList() async {
    await Future.delayed(Duration(seconds: 2));
    ProductsRepository().getProductSale();
    setState(() {
    });
  }

  _buildProductGrid(double _gridSize, double childAspectRatio) {
    return FutureBuilder(
      future:getProductsSale(),
      initialData: List<Product>.from([]),
      builder: (context, snapshot) {
        // snapshot.data chính là list products á
        if ((snapshot.data == null || snapshot.data.length == 0) &&
            !isLoading)
          return Column(
            children: <Widget>[
              new Container(
                  child: Center(
                    child: Text("Hiện không có sản phẩm khuyến mãi nào!"),
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
        else{
          if(widget.selectedSortType=='Giá tăng dần'){
            _productsSale=sortByPrice_Increase(snapshot.data);
          } else if(widget.selectedSortType=='Giá giảm dần'){
            _productsSale=sortByPrice_Decrease(snapshot.data);
          } else if(widget.selectedSortType=='Sắp hết khuyến mãi'){
            _productsSale=sortByDate_NearlyExpired(snapshot.data);
          }else if(widget.selectedSortType=='Giảm giá cao'){
            _productsSale=sortByDiscount_Decrease(snapshot.data);
          }else if(widget.selectedSortType=='Giảm giá thấp'){
            _productsSale=sortByDiscount_Increase(snapshot.data);
          }
          else{
            _productsSale = snapshot.data;
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
                                    itemCount: _productsSale.length,
                                    gridDelegate:
                                    new SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: childAspectRatio),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return new Padding(
                                          padding: EdgeInsets.only(
                                              top: index % 2 == 0 ? 10 : 0,
                                              right: index % 2 == 0 ? 5 : 0,
                                              left: index % 2 == 1 ? 5 : 0,
                                              bottom: index % 2 == 1 ? 10 : 0),
                                          child: ProductWidget(
                                              product: _productsSale[index],
                                            onRefresh: refeshList,),);
                                    }),
                                onRefresh: refeshList,
                              ),
                            ))
                      ])),
                  new MinimalCart(),
                ])),
            //new MinimalCart(_gridSize)
          ]);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double _gridSize =
        MediaQuery.of(context).size.height - 80; //88% of screen
    double childAspectRatio = MediaQuery.of(context).size.width /
        (MediaQuery.of(context).size.height / 1.0);
    return _buildProductGrid(_gridSize, childAspectRatio);
  }

  sortByPrice_Decrease(List<Product> pros) {
    List<Product> sortPros = [];
    pros.sort((a, b) => (b.price-(b.price*b.discount~/100)).compareTo(a.price-(a.price*a.discount~/100)));
    for (var p in pros) {
      sortPros.add(p);
    }
    return sortPros;
  }

  sortByPrice_Increase(List<Product> pros) {
    List<Product> sortPros = [];
    pros.sort((a, b) => (a.price-(a.price*a.discount~/100)).compareTo((b.price-(b.price*b.discount~/100))));
    for (var p in pros) {
      sortPros.add(p);
    }
    return sortPros;
  }

  sortByDate_NearlyExpired(List<Product> pros) {
    List<Product> sortPros = [];
    pros.sort((a, b) => a.endSale.compareTo(b.endSale));

    for (var p in pros) {
      sortPros.add(p);
    }
    return sortPros;
  }

  sortByDiscount_Decrease(List<Product> pros) {
    List<Product> sortPros = [];
    pros.sort((a, b) => b.discount.compareTo(a.discount));
    for (var p in pros) {
      sortPros.add(p);
    }
    return sortPros;
  }

  sortByDiscount_Increase(List<Product> pros) {
    List<Product> sortPros = [];
    pros.sort((a, b) => a.discount.compareTo(b.discount));
    for (var p in pros) {
      sortPros.add(p);
    }
    return sortPros;
  }
}
