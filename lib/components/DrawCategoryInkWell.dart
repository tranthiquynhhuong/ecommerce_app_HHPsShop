import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/bloc/CategoryBloc.dart';
import 'package:grocery_shop_flutter/models/Category.dart';
import 'package:grocery_shop_flutter/views/Category.dart';

class DrawCategoryInkWell extends StatefulWidget {
  @override
  _DrawCategoryInkWellState createState() => _DrawCategoryInkWellState();
}

class _DrawCategoryInkWellState extends State<DrawCategoryInkWell> {
  final _cateBloc = new CategoryBloc();
  @override
  Widget build(BuildContext context) {
//    _cateBloc.fetchCates();
    return new StreamBuilder(
        initialData: _cateBloc.categories,
        stream: _cateBloc.observableCate,
        builder: (context, snapshot) {
          if (snapshot.data == null)
            return Container(
              height: 300,
            );
          List<Category> _categories = snapshot.data;
          return Container(
            color: Colors.white,
            height: 300,
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
                              fontWeight: FontWeight.bold, fontSize: 15),
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
          );
        });
  }
}
