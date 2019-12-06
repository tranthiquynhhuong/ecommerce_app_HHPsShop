import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/bloc/CategoryBloc.dart';
import 'package:grocery_shop_flutter/models/Category.dart';
import 'package:grocery_shop_flutter/views/Home.dart';
import 'Category.dart';
import 'Search.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>  with AutomaticKeepAliveClientMixin<CategoriesPage>{
  ScrollController _scrollController = new ScrollController();
  final _cateBloc = new CategoryBloc();

  bool isLoading = true;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _cateBloc.fetchCates().then((var a) {
      setState(() {
        isLoading = false;
      });
    });
    // TODO: implement initState
    super.initState();
    print('DetailCommentHeaderState initState');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("DetailCommentListHeader dispose");
  }

  Future<Null> refeshList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _cateBloc.fetchCates().then((var a) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          backgroundColor: Colors.amber,
          centerTitle: true,
          title: Text("Danh mục sản phẩm",
              style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          leading: new IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => new MyHomePage()));
            },
          ),
          actions: <Widget>[
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
        body: StreamBuilder(
            initialData: _cateBloc.categories,
            stream: _cateBloc.observableCate,
            builder: (context, snapshot) {
              if (snapshot.data == null)
                return Container(
                  height: 300,
                );
              List<Category> _categories = snapshot.data;
              return RefreshIndicator(
                child: ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CategoryPage(_categories[index]),
                            ));
                      },
                      child: ListTile(
                        title: Row(
                          children: <Widget>[
                            Text(
                              _categories[index].name.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15,color: Colors.black),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              width: 30,
                              height: 30,
                              child: Image.network(
                                  _categories[index].imgURL.toString()),
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
                    );
                  },
                ),
                onRefresh: refeshList,
              );
            }
        ),);
  }
}
