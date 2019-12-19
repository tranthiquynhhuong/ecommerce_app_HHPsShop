import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/components/FeedBackWidget.dart';
import 'package:grocery_shop_flutter/models/Feedback.dart';

class FeedBackList extends StatefulWidget {
  final List<FeedBack> items;
  final Function onSubmit;

  FeedBackList({this.items, this.onSubmit});
  @override
  _FeedBackListState createState() => _FeedBackListState();
}

class _FeedBackListState extends State<FeedBackList> {
  Future<Null> refeshListFB() async {
    await Future.delayed(Duration(seconds: 2));
    widget.onSubmit();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;

    return Container(
        height: height-350,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: RefreshIndicator(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                return FeedBackWidget(
                  fb: widget.items[index],
                );
              },
            ),
            onRefresh: refeshListFB,
          ),
        ));
  }
}
