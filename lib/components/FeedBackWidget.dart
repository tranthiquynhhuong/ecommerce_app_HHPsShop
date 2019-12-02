import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
        Text(fb.email.toString(), style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
        Text(getDate(DateTime.parse(fb.date)).toString(),
            style: TextStyle(fontSize: 14)),
        RatingBar(
          initialRating: fb.rating,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 20,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
        ListTile(
          title: Text(
            fb.content,
            style: TextStyle(fontSize: 14,color: Colors.grey),
          ),
        ),
        Divider(
          color: Colors.amber,
        ),
      ],
    );
  }
}
