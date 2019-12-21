import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grocery_shop_flutter/repositories/FeedbackRepository.dart';

class FeedBackField extends StatefulWidget {
  final String uid;
  final String proID;
  final Function(String, double) onSubmit;
  FeedBackField({this.onSubmit, this.proID, this.uid});

  @override
  _FeedBackFieldState createState() => _FeedBackFieldState();
}

class _FeedBackFieldState extends State<FeedBackField> {
  bool _checkValid = false;
  TextEditingController comment = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  double _rating;

  @override
  void initState() {
    _rating = 0.0;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_checkValid == true) {
      return Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            color: Colors.amber.shade400,
            borderRadius: BorderRadius.all(const Radius.circular(30))),
        child: Center(
            child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          strokeWidth: 2,
        )),
      );
    }
    return Container(
      height: 200,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Center(
            child: RatingBar(
              initialRating: _rating,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
                setState(() {
                  _rating = rating;
                });
              },
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                height: 160,
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: comment,
                    minLines: 10,
                    maxLines: 25,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: 'Viết đánh giá cho sản phẩm này tại đây...',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.blue,
                ),
                tooltip: 'Gửi đánh giá về sản phẩm',
                onPressed: sentFeedback,
              ),
            ],
          ),
        ],
      ),
    );
  }

  sentFeedback() async {
    setState(() {
      _checkValid = true;
    });

    try {
      bool response = await FeedBackRepository()
          .checkUserWasBought(widget.uid, widget.proID);

      setState(() {
        _checkValid = false;
      });

      if (response == true) {
        if (_rating == 0.0) {
          Fluttertoast.showToast(
              msg:
                  "Vui lòng xếp hạng cho sản phẩm bằng cách chọn các biểu tượng ngôi sao (1->5) !",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 3,
              backgroundColor: Colors.amber,
              textColor: Colors.black,
              fontSize: 16.0);
        }
        if (comment.text.length == 0) {
          Fluttertoast.showToast(
              msg: "Vui lòng nhập đánh giá cho sản phẩm !",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 3,
              backgroundColor: Colors.amber,
              textColor: Colors.black,
              fontSize: 16.0);
        }
        if (comment.text.length != 0 && _rating != 0.0) {
          setState(() {
            _checkValid = true;
          });
          FocusScope.of(context).requestFocus(new FocusNode());
          bool response = await widget.onSubmit(comment.text, _rating);
          if (response) {
            comment.clear();
            setState(() {
              _checkValid = false;
              _rating = 0.0;
            });
            print("Rating ==========> " + _rating.toString());
          }
        }
      } else if (response == false) {
        Fluttertoast.showToast(
            msg: "Bạn chưa từng mua sản phẩm này nên không thể viết đánh giá !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 3,
            backgroundColor: Colors.amber,
            textColor: Colors.black,
            fontSize: 16.0);
      }
    } catch (e) {
      _checkValid = false;
      print("=======> sent feedback err: " + e);
    }
  }
}
