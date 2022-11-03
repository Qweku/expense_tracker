import 'package:expense_tracker/models/Models.dart';
import 'package:flutter/foundation.dart';

class TransactionProvider with ChangeNotifier {
  AccountModel _account = AccountModel();
  List<AccountModel> _accountList = [];
  List<TransactionModel> _transactionItem = [];

  AccountModel get account => _account;
  List<AccountModel> get accountList => _accountList;
  List<TransactionModel> get transactionItem => _transactionItem;

  set accountList(List<AccountModel> accountList) {
    _accountList = accountList;
    notifyListeners();
  }

  set transactionItem(List<TransactionModel> transactionItem) {
    _transactionItem = transactionItem;
    notifyListeners();
  }

  void addAccount(AccountModel accountDetail) {
    _accountList.add(accountDetail);
    notifyListeners();
  }

  void addTransaction(TransactionModel transactionDetail) {
    _transactionItem.add(transactionDetail);
    notifyListeners();
  }
}
