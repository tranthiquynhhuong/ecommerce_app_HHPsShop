import 'package:flutter/material.dart';

class FeedBackField extends StatefulWidget {
  final Function(String) onSubmit;
  FeedBackField({this.onSubmit});

  @override
  _FeedBackFieldState createState() => _FeedBackFieldState();
}

class _FeedBackFieldState extends State<FeedBackField> {
  TextEditingController comment = new TextEditingController();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            height: 200,
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
    );
  }

  sentFeedback() async {
    if (comment.text != "") {
      FocusScope.of(context).requestFocus(new FocusNode());
      bool response = await widget.onSubmit(comment.text);
      if (response) {
        comment.clear();
      }
    }
  }
}
