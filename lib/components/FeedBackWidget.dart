import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/models/Feedback.dart';
import 'package:intl/intl.dart';

class FeedBackWidget extends StatelessWidget {
  final FeedBack fb;
  FeedBackWidget({this.fb});

  getDate(DateTime dateTimeInput) {
    String processedDate;
    processedDate = DateFormat('dd/MM/yyyy - H:m:s').format(dateTimeInput);
    return processedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(fb.email,style: TextStyle(fontSize: 14),),
          trailing: Text(getDate(DateTime.parse(fb.date)).toString(),style: TextStyle(fontSize: 14)),
          subtitle: Text(fb.content),

        ),

        Divider(
          color: Colors.amber,
        ),
      ],
    );
  }
}
