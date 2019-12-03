import 'package:grocery_shop_flutter/models/Receipt.dart';
import 'package:grocery_shop_flutter/repositories/ReceiptRepository.dart';
import 'package:rxdart/rxdart.dart';

class ReceiptBloc {
  final _receiptRepo = ReceiptRepository();
  static ReceiptBloc _receiptBloc;

  PublishSubject<List<Receipt>> _publishSubjectReceipt;
  PublishSubject<List<Receipt>> _publishSubjectReceiptDone;
  PublishSubject<List<Receipt>> _publishSubjectReceiptCancel;
  PublishSubject<List<Receipt>> _publishSubjectReceiptPending;

  List<Receipt> _receipts = [];
  List<Receipt> _doneReceipts = [];
  List<Receipt> _cancelReceipts = [];
  List<Receipt> _pendingReceipts = [];

  List<Receipt> get receipts => _receipts;
  List<Receipt> get doneReceipts => _doneReceipts;
  List<Receipt> get cancelReceipts => _cancelReceipts;
  List<Receipt> get pendingReceipts => _pendingReceipts;

  factory ReceiptBloc() {
    if (_receiptBloc == null) _receiptBloc = new ReceiptBloc._();

    return _receiptBloc;
  }

  ReceiptBloc._() {
    _publishSubjectReceipt = new PublishSubject<List<Receipt>>();
    _publishSubjectReceiptDone = new PublishSubject<List<Receipt>>();
    _publishSubjectReceiptCancel = new PublishSubject<List<Receipt>>();
    _publishSubjectReceiptPending = new PublishSubject<List<Receipt>>();
  }

  Observable<List<Receipt>> get observableReceipt =>
      _publishSubjectReceipt.stream;
  Observable<List<Receipt>> get observableReceiptDone =>
      _publishSubjectReceiptDone.stream;
  Observable<List<Receipt>> get observableReceiptCancel =>
      _publishSubjectReceiptCancel.stream;
  Observable<List<Receipt>> get observableReceiptPending =>
      _publishSubjectReceiptPending.stream;

  Future<bool> getReceiptPending(String userID) async {
    try {
      _pendingReceipts = await _receiptRepo.getUserReceiptPending(userID);
      if (_pendingReceipts != null) {
        _updateReceiptPending();
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getReceiptWaiting(String userID) async {
    try {
      _receipts = await _receiptRepo.getUserReceiptWaiting(userID);
      if (_receipts != null) {
        _updateReceipt();
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getReceiptDone(String userID) async {
    try {
      _doneReceipts = await _receiptRepo.getUserReceiptDone(userID);
      if (_doneReceipts != null) {
        _updateReceiptDone();
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getReceiptCancel(String userID) async {
    try {
      _cancelReceipts = await _receiptRepo.getUserReceiptCancel(userID);
      if (_cancelReceipts != null) {
        _updateReceiptCancel();
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  void _updateReceipt() {
    _publishSubjectReceipt.sink.add(_receipts);
  }

  void _updateReceiptDone() {
    _publishSubjectReceiptDone.sink.add(_doneReceipts);
  }

  void _updateReceiptCancel() {
    _publishSubjectReceiptCancel.sink.add(_cancelReceipts);
  }

  void _updateReceiptPending() {
    _publishSubjectReceiptPending.sink.add(_pendingReceipts);
  }

  dispose() {
    _receiptBloc = null;
    _publishSubjectReceipt.close();
    _publishSubjectReceiptDone.close();
    _publishSubjectReceiptCancel.close();
    _publishSubjectReceiptPending.close();
  }
}
