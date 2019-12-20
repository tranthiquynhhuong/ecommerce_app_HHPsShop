import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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

  Future<Null> refeshListFB() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      FeedBackRepository()
          .getFeedbackByID(widget.product.proID);
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
                    double _ratingSUM = 0.0;
                    double _ratingAVG = 0.0;
                    int feedbackCout = 0;

                    for(var fb in _lstSortFb){
                     if(fb.invalid==1){
                       _ratingSUM = _ratingSUM + fb.rating;
                       _ratingAVG = _ratingSUM/_lstSortFb.length;
                       feedbackCout++;
                     }
                    }

                    return Column(
                      children: <Widget>[
                        Container(
                          height: 50,

                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide( //                   <--- left side
                                color: Colors.grey,
                                width: 3.0,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                RatingBar(
                                  initialRating: _ratingAVG,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 25,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                                Text(_ratingAVG.toString() + " / 5"+" ("+feedbackCout.toString()+" Đánh giá)",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                        ),
                      FeedBackList(
                      items: _lstSortFb,
                      onSubmit: refeshListFB,
                    ),
                      ],
                    );
                  },
                ),
                FeedBackField(onSubmit: (fb,rating) async {
                  bool response = await FeedBackRepository().createFeedback(
                      _userBloc.userInfo.email,fb,rating, widget.product.proID);
                  bool checkUserWasBought = await FeedBackRepository().checkUserWasBought(
                      _userBloc.userInfo.userID,widget.product.proID);
                  if (response==true && checkUserWasBought ==true) {
                    setState(() {});
                  }
                  return response;
                },uid: _userBloc.userInfo.userID,proID: widget.product.proID),
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
