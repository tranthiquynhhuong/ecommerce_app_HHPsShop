import 'package:flutter/material.dart';
import 'package:grocery_shop_flutter/bloc/OrderBloc.dart';
import 'package:grocery_shop_flutter/bloc/ReceiptBloc.dart';
import 'package:grocery_shop_flutter/bloc/UserBloc.dart';
import 'package:grocery_shop_flutter/models/Order.dart';
import 'package:grocery_shop_flutter/models/Receipt.dart';
import 'package:grocery_shop_flutter/repositories/OrderRepository.dart';
import 'package:grocery_shop_flutter/repositories/ProductsRepository.dart';
import 'package:grocery_shop_flutter/repositories/ReceiptRepository.dart';
import 'package:intl/intl.dart';

import 'AppTools.dart';

class MyOrderWidget extends StatefulWidget {
  Receipt receipt;
  bool isPending;

  MyOrderWidget({this.receipt, this.isPending});
  @override
  _MyOrderWidgetState createState() => _MyOrderWidgetState();
}

class _MyOrderWidgetState extends State<MyOrderWidget> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  ReceiptRepository receiptRepository = new ReceiptRepository();
  final _receiptBloc = ReceiptBloc();
  final _userBloc = UserBloc();
  final format = new NumberFormat("#,##0");


  void initState() {
    super.initState();
  }

  getDate(DateTime dateTimeInput) {
    String processedDate;
    processedDate = DateFormat('dd/MM/yyyy - H:m:s').format(dateTimeInput);
    return processedDate;
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Mã đơn hàng: " + widget.receipt.receiptID.toString()),
                Text("Thời gian đặt hàng: " +
                    getDate(DateTime.parse(widget.receipt.billDate))),
                Text("Tổng số sản phẩm: " + widget.receipt.totalPro.toString()),
                Text("Tổng tiền: " +format.format( widget.receipt.totalPrice).toString()+"đ"),
                Text("Địa chỉ giao hàng: " + widget.receipt.deliveryAddress),
                Divider(
                  color: Colors.black,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
              ],
            ),
            subtitle: Container(
                height: 150,
                child: FutureBuilder(
                    future: OrderRepository().getOrderByReceiptID(widget.receipt.receiptID),
                    initialData: List<Order>.from([]),
                    builder: (context, snapshot) {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          List<Order> orders=snapshot.data;
                          return new Row(
                            children: <Widget>[
                              Expanded(
                                child: Icon(
                                  Icons.playlist_add_check,
                                  color: Colors.black,
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                child: Text(
                                  "  " +
                                      orders[index].product.name+
                                      " x " +
                                      orders[index].quantity.toString() +
                                      " = " +
                                      format.format(orders[index].orderPrice).toString() + "đ",
                                  style: TextStyle(fontSize: 14),
                                ),
                                flex: 10,
                              ),
                            ],
                          );
                        },
                      );
                    })),
          ),
          widget.isPending == true
              ? ListTile(
                  trailing: RaisedButton.icon(
                    color: Colors.red,
                    onPressed: () {
                      _showConfirmDialog();
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: Text(
                      "Hủy đơn hàng",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("XÁC NHẬN"),
          content: new Text("Bạn có chắc chắn muốn xóa đơn hàng đã chọn?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              color: Colors.green,
              child: new Text("Đồng ý", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                displayProgressDialog(context);
                bool response = await receiptRepository.updateCancelReceipt(
                    receiptID: widget.receipt.receiptID);
                if (response == true) {
                  await _receiptBloc
                      .getReceiptWaiting(_userBloc.userInfo.userID);
                  await _receiptBloc
                      .getReceiptCancel(_userBloc.userInfo.userID);
                  await _receiptBloc
                      .getReceiptPending(_userBloc.userInfo.userID);
                  await _receiptBloc.getReceiptDone(_userBloc.userInfo.userID);
                  Navigator.of(context).pop();
//                  setState(() {
//
//                  });
                  closeProgressDialog(context);
                } else if (response == false) {
                  showSnackbar("Hủy đơn hàng thất bại !", scaffoldKey);
                  closeProgressDialog(context);
                }
              },
            ),
            new FlatButton(
              color: Colors.red,
              child: new Text("Hủy", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
