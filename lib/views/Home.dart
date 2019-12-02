import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/bloc/CartBloc.dart';
import 'package:grocery_shop_flutter/bloc/UserBloc.dart';
import 'package:grocery_shop_flutter/components/DrawMyReceipt.dart';
import 'package:grocery_shop_flutter/components/DrawPromotion.dart';
import 'package:grocery_shop_flutter/components/GridShop.dart';
import 'package:grocery_shop_flutter/components/CartManager.dart';
import 'package:grocery_shop_flutter/views/AccountManagement.dart';
import 'package:grocery_shop_flutter/views/Categories.dart';
import 'package:grocery_shop_flutter/views/SignIn.dart';
import 'Search.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showCart = false;
  CartBloc _cartBloc;
  var _dropDownMenuItems = [
    'Giá tăng dần',
    'Giá giảm dần',
    'Mới nhất',
    'Cũ nhất'
  ];
  String _selectedType;
  ScrollController _scrollController = new ScrollController();
  final _userBloc = UserBloc();

  @override
  initState() {
    _scrollController = new ScrollController();
    _cartBloc = new CartBloc();
    super.initState();
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems(
      List _typeSortProByPrice) {
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
          title: Text("HHPs Shop",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          actions: <Widget>[
            new DropdownButton<String>(
              value: _selectedType,
              icon: Icon(Icons.sort),
              items: _dropDownMenuItems.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(
                    value,
                    style: TextStyle(fontSize: 14),
                  ),
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
                }),
          ],
        ),
        drawer: Drawer(
            child: new ListView(children: <Widget>[
          StreamBuilder(
              initialData: _userBloc.userInfo,
              stream: _userBloc.observableUser,
              builder: (context, snapshot) {
                return new UserAccountsDrawerHeader(
                  accountName: Text(
                    snapshot.data.fullname,
                    style: TextStyle(color: Colors.black),
                  ),
                  accountEmail: Text(
                    snapshot.data.email,
                    style: TextStyle(color: Colors.black),
                  ),
                  currentAccountPicture: GestureDetector(
                    child: _userBloc.userInfo.imgURL == ""
                        ? new CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          )
                        : new CircleAvatar(
                            backgroundColor: Colors.grey,
                            //child: Image.network(_userBloc.userInfo.imgURL),
                            backgroundImage:
                                NetworkImage(_userBloc.userInfo.imgURL),
                          ),
                  ),
                  decoration: new BoxDecoration(
                    color: Colors.amber,
                  ),
                );
              }),

          ///My Info
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => new AccountManagementPage()));
            },
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Text(
                    "Quản lý tài khoản",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    width: 30,
                    height: 30,
                    child: Icon(
                      Icons.perm_contact_calendar,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              trailing: Text(
                ">",
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),

          ///Category
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => new CategoriesPage()));
            },
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Text(
                    "Danh mục sản phẩm",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    width: 30,
                    height: 30,
                    child: Icon(
                      Icons.format_list_bulleted,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              trailing: Text(
                ">",
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),

          ///My Cart
          InkWell(
            onTap: () {
              Navigator.pop(context);
              _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(seconds: 2));
              setState(() {
                _showCart = !_showCart;
              });
            },
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Text(
                    "Giỏ hàng của tôi",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    width: 30,
                    height: 30,
                    child: Icon(
                      Icons.shopping_cart,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              trailing: Text(
                ">",
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),

          ///My Noti
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Text(
                    "Thông báo",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    width: 30,
                    height: 30,
                    child: Icon(
                      Icons.notifications_active,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              trailing: Text(
                ">",
                style: TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Divider(
            color: Colors.amber,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),

          ///About
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Text(
                    "Thông tin ứng dụng",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    width: 30,
                    height: 30,
                    child: Icon(
                      Icons.info,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              trailing: Text(
                ">",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),

          ///Setting
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: ListTile(
              title: Row(
                children: <Widget>[
                  Text(
                    "Cài đặt",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    width: 30,
                    height: 30,
                    child: Icon(
                      Icons.settings,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              trailing: Text(
                ">",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Divider(
            color: Colors.amber,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          DrawPromotion(),
          Divider(
            color: Colors.amber,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),

          ///Logout
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              height: 30,
              child: RaisedButton(
                onPressed: () async {
                  bool _isLogout = await _userBloc.logout();
                  if (_isLogout) {
                    Navigator.of(context).pushAndRemoveUntil(
                        new MaterialPageRoute(
                            builder: (context) => new SignIn()),
                            (Route<dynamic> route) => false);
                  } else {
                    print('Đăng xuất thất bại');
                  }
                },
                color: Colors.red,
                child: Text('Đăng xuất',
                    style: TextStyle(fontSize: 15, color: Colors.white)),
              ),
            ),
          ),
        ])),
        body: new Stack(children: <Widget>[
          new CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              controller: _scrollController,
              slivers: <Widget>[
                new SliverToBoxAdapter(
                    child: new GridShop(
                  selectedSortType: _selectedType,
                )),
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
    //_userBloc.dispose();

    super.dispose();
  }
}
