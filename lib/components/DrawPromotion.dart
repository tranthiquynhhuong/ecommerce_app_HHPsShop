import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/views/Promotion.dart';

class DrawPromotion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.white,
      height: 50,
      child: ListTile(
        title: Row(
          children: <Widget>[
            Text(
              "Khuyến mãi",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              width: 30,
              height: 30,
              child: Image.asset('assets/images/sale.png'),
            ),
          ],
        ),
        trailing: RaisedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PromotionPage()));
          },
          color: Colors.amber,
          child: Text('Xem ngay >',
              style: TextStyle(fontSize: 15, color: Colors.white)),
        ),
      ),
    );
  }
}
