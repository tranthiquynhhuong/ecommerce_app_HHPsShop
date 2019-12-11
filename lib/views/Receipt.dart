import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/components/CancelReceiptTabBarView.dart';
import 'package:grocery_shop_flutter/components/DoneReceiptTabBarView.dart';
import 'package:grocery_shop_flutter/components/PendingReceiptTabBarView.dart';
import 'package:grocery_shop_flutter/components/WaitingReceiptTabBarView.dart';

class ReceiptPage extends StatefulWidget {
  @override
  _ReceiptPageState createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Grocery Store',
      theme: ThemeData(
        primaryColor: Colors.amber,
        fontFamily: 'JosefinSans',
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: new IconThemeData(color: Colors.black),
            backgroundColor: Colors.amber,
            centerTitle: true,
            title: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
//                    Navigator.of(context).push(new MaterialPageRoute(
//                        builder: (context) => new MyHomePage()));
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: Text(
                        "<",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0),
                  child: Text("Đơn hàng của bạn ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                Icon(Icons.receipt),
              ],
            ),
            bottom: TabBar(
              indicatorColor: Colors.grey,
              tabs: [
                Tab(
                    icon: Icon(
                      Icons.hourglass_full,
                      color: Colors.black,
                    )),
                Tab(
                    icon: Icon(
                  Icons.cancel,
                  color: Colors.red,
                )),
                Tab(
                    icon: Icon(
                      Icons.local_shipping,
                      color: Colors.blue,
                    )),
                Tab(
                    icon: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              PendingReceiptTabBarView(),
              CancelReceiptTabBarView(),
              WaitingReceiptTabBarView(),
              DoneReceiptTabBarView(),
            ],
          ),
        ),
      ),
    );
  }
}
