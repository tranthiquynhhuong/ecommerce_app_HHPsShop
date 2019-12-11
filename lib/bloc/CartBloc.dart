import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:grocery_shop_flutter/models/Product.dart';
import 'package:grocery_shop_flutter/models/Order.dart';
import 'package:grocery_shop_flutter/models/Cart.dart';

class CartBloc {
  static CartBloc _cartBloc;
  Cart _currentCart;
  Order _lastOrder;
  PublishSubject<Cart> _publishSubjectCart;
  PublishSubject<Order> _publishSubjectOrder;

  factory CartBloc() {
    if (_cartBloc == null) _cartBloc = new CartBloc._();

    return _cartBloc;
  }

  CartBloc._() {
    _currentCart = new Cart();
    _publishSubjectCart = new PublishSubject<Cart>();
    _publishSubjectOrder = new PublishSubject<Order>();
  }

  Observable<Cart> get observableCart => _publishSubjectCart.stream;
  Observable<Order> get observableLastOrder => _publishSubjectOrder.stream;

  void _updateCart() {
    _publishSubjectCart.sink.add(_currentCart);
  }

  void _updateLastOrder() {
    _publishSubjectOrder.sink.add(_lastOrder);
  }

  void addOrderToCart(Product product, int quantity) {
    int orderPrice = 0;
    if (product.isSale == 1)
      orderPrice = (product.price - (product.price * product.discount) ~/ 100)*quantity;
    else
      orderPrice = product.price*quantity;
    _lastOrder = new Order(
        product, quantity, Timestamp.now().seconds.toString(), orderPrice);
    _currentCart.addOrder(_lastOrder);
    _updateLastOrder();
    _updateCart();
  }

  void removerOrderOfCart(Order order) {
    _currentCart.removeOrder(order);
    _updateCart();
  }

  Cart get currentCart => _currentCart;

  Order get lastOrder => _lastOrder;

  clear() {
    _currentCart = new Cart();
    _updateCart();
    _cartBloc = null;
    _publishSubjectCart.close();
    _publishSubjectOrder.close();
  }

  dispose() {
    _cartBloc = null;
    _publishSubjectCart.close();
    _publishSubjectOrder.close();
  }
}
