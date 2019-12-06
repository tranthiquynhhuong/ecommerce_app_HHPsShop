import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/bloc/CartBloc.dart';
import 'package:grocery_shop_flutter/components/GridSaleProduct.dart';
import 'package:grocery_shop_flutter/components/CartManager.dart';
import 'Search.dart';

class PromotionPage extends StatefulWidget {
  @override
  _PromotionPageState createState() => _PromotionPageState();
}

class _PromotionPageState extends State<PromotionPage> {
  var _dropDownMenuItems=['Giá tăng dần','Giá giảm dần','Khuyến mãi mới nhất','Sắp hết khuyến mãi','Giảm giá cao','Giảm giá thấp'];
  String _selectedType;
  bool _showCart = false;
  CartBloc _cartBloc;

  ScrollController _scrollController = new ScrollController();

  @override
  initState() {
    _scrollController = new ScrollController();
    _cartBloc = new CartBloc();

    super.initState();
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems(List _typeSortProByPrice) {
    List<DropdownMenuItem<String>> items = List();
    for (String t in _typeSortProByPrice) {
      items.add(
        DropdownMenuItem(
          value: t,
          child: Text(t),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(String selectedTypeSort) {
    setState(() {
      _selectedType = selectedTypeSort;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          backgroundColor: Colors.amber,
          title: Container(
            width: 40,
            height: 40,
            child: Image.asset('assets/images/sale.png'),
          ),
          actions: <Widget>[
            new DropdownButton<String>(
              value: _selectedType,
              icon: Icon(Icons.sort,color: Colors.black,),
              items: _dropDownMenuItems.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value,style: TextStyle(fontSize: 14,color: Colors.black,),),
                );
              }).toList(),
              onChanged: onChangeDropdownItem,
            ),
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
        body: new Stack(children: <Widget>[
          new CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              controller: _scrollController,
              slivers: <Widget>[
                new SliverToBoxAdapter(child: new GridSaleProduct(selectedSortType: _selectedType,)),
                new SliverToBoxAdapter(child: new CartManager()),
              ]),
          new Align(
              alignment: Alignment.bottomRight,
              child: new Container(
                  margin: EdgeInsets.only(right: 10, bottom: 10),
                  child: new FloatingActionButton(
                      onPressed: () {
                        if (_showCart)
                          _scrollController.animateTo(
                              _scrollController.position.minScrollExtent,
                              curve: Curves.fastOutSlowIn,
                              duration: Duration(seconds: 2));
                        else
                          _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              curve: Curves.fastOutSlowIn,
                              duration: Duration(seconds: 2));

                        setState(() {
                          _showCart = !_showCart;
                        });
                      },
                      backgroundColor: Colors.amber,
                      child: new Icon(
                          _showCart ? Icons.close : Icons.shopping_cart))))
        ]));
  }

  @override
  void dispose() {
    _cartBloc.dispose();
    super.dispose();
  }
}
