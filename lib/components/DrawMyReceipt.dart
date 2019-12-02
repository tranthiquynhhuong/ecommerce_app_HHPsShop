//import 'package:flutter/material.dart';
//import 'package:grocery_shop_flutter/views/Receipt.dart';
//
//class DrawMyReceipt extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return InkWell(
//      onTap: () {
//        Navigator.pop(context);
//        Navigator.of(context).push(
//            new MaterialPageRoute(builder: (context) => new ReceiptPage()));
//      },
//      child: ListTile(
//        title: Row(
//          children: <Widget>[
//            Text(
//              "Đơn hàng của tôi",
//              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//            ),
//            Container(
//              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
//              width: 30,
//              height: 30,
//              child: Icon(
//                Icons.receipt,
//                color: Colors.amber,
//              ),
//            ),
//          ],
//        ),
//        trailing: Text(
//          ">",
//          style: TextStyle(
//              color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
//        ),
//      ),
//    );
//  }
//}
