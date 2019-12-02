import 'package:grocery_shop_flutter/models/Order.dart';
import 'package:grocery_shop_flutter/repositories/OrderRepository.dart';
import 'package:rxdart/rxdart.dart';

class OrderBloc {
  final _orderRepo = OrderRepository();
  static OrderBloc _orderBloc;

  PublishSubject<List<Order>> _publishSubjectOrder;
  List<Order> _orders = [];
  List<Order> get orders => _orders;

  factory OrderBloc() {
    if (_orderBloc == null) _orderBloc = new OrderBloc._();

    return _orderBloc;
  }

  OrderBloc._() {
    _publishSubjectOrder = new PublishSubject<List<Order>>();
  }

  Observable<List<Order>> get observableOrder => _publishSubjectOrder.stream;

  Future fetchOrders(String receiptID) async {
    try {
      List<Order> _res = await _orderRepo.getOrderByReceiptID(receiptID);
      _orders = _res;
      _updateOrders();
    } catch (e) {
      print(e);
    }
  }

  void _updateOrders() {
    _publishSubjectOrder.sink.add(_orders);
  }

  dispose() {
    _orderBloc = null;
    _publishSubjectOrder.close();
  }
}
