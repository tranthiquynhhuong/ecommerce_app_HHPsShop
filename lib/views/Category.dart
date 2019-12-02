import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/components/GridCategoryProduct.dart';
import 'package:grocery_shop_flutter/components/CartManager.dart';
import 'package:grocery_shop_flutter/models/Category.dart';
import 'package:grocery_shop_flutter/views/Categories.dart';

import 'Search.dart';

class CategoryPage extends StatefulWidget {
  final Category cat;
  CategoryPage(this.cat);
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<CategoryPage> {
  bool _showCart = false;
  var _dropDownMenuItems=['Giá tăng dần','Giá giảm dần','Mới nhất','Cũ nhất'];
  String _selectedType;
  ScrollController _scrollController = new ScrollController();

  @override
  initState() {
    _scrollController = new ScrollController();
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
          leading: new IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => new CategoriesPage()));
            },
          ),
          backgroundColor: Colors.amber,
          title: Row(
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                child:
                    CachedNetworkImage(imageUrl: widget.cat.imgURL.toString()),
              ),
            ],
          ),
          actions: <Widget>[
            new DropdownButton<String>(
              value: _selectedType,
              icon: Icon(Icons.sort),
              items: _dropDownMenuItems.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value,style: TextStyle(fontSize: 14),),
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
                new SliverToBoxAdapter(
                    child: new GridCategoryProduct(widget.cat.catID,_selectedType)),
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
    super.dispose();
  }
}
