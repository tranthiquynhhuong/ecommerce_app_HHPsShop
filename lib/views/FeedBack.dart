import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/bloc/UserBloc.dart';
import 'package:grocery_shop_flutter/components/FeedBackField.dart';
import 'package:grocery_shop_flutter/components/FeedBackList.dart';
import 'package:grocery_shop_flutter/models/Feedback.dart';
import 'package:grocery_shop_flutter/models/Product.dart';
import 'package:grocery_shop_flutter/repositories/FeedbackRepository.dart';

class FeedBackPage extends StatefulWidget {
  final Product product;
  FeedBackPage({this.product});

  @override
  _FeedBackPageState createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  final _userBloc = UserBloc();
  List<FeedBack> _feedBacks = [];
  List<FeedBack> _lstSortFb = [];

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.black),
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text("Đánh giá sản phẩm",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      ),
      body: new Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                FutureBuilder(
                  future: FeedBackRepository()
                      .getFeedbackByID(widget.product.proID),
                  initialData: [],
                  builder: (context, snapshot) {
                    if (snapshot.data == null) return Container();
                    _feedBacks = List<FeedBack>.from(snapshot.data);
                    _lstSortFb = sortByDate(_feedBacks);

                    return FeedBackList(
                      items: _lstSortFb,
                    );
                  },
                ),
                FeedBackField(onSubmit: (fb,rating) async {
                  bool response = await FeedBackRepository().createFeedback(
                      _userBloc.userInfo.email,fb,rating, widget.product.proID);
                  if (response) {
                    setState(() {});
                  }
                  return response;
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  sortByDate(List<FeedBack> fbs) {
    List<FeedBack> sortFbs = [];
    fbs.sort((a, b) => b.date.compareTo(a.date));
    for (var fb in fbs) {
      sortFbs.add(fb);
    }
    return sortFbs;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
