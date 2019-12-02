import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/components/FeedBackWidget.dart';
import 'package:grocery_shop_flutter/models/Feedback.dart';
import 'package:intl/intl.dart';

class FeedBackList extends StatefulWidget {
  final List<FeedBack> items;
  FeedBackList({this.items});

  @override
  _FeedBackListState createState() => _FeedBackListState();
}

class _FeedBackListState extends State<FeedBackList> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListView.builder(
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              return FeedBackWidget(
                fb: widget.items[index],
              );
            },
          ),
        ));
  }
}
