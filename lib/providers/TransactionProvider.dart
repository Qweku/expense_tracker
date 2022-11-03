import 'package:expense_tracker/models/Models.dart';
import 'package:flutter/foundation.dart';

class TransactionProvider with ChangeNotifier {
  AccountModel _account = AccountModel();
  List<AccountModel> _accountList = [];
  List<TransactionModel> _transactionList = [];

  AccountModel get account => _account;
  List<AccountModel> get accountList => _accountList;
  List<TransactionModel> get transactionList => _transactionList;

  set accountList(List<AccountModel> accountList) {
    _accountList = accountList;
    notifyListeners();
  }

  set transactionList(List<TransactionModel> transactionList) {
    _transactionList = transactionList;
    notifyListeners();
  }

  void addAccount(AccountModel accountDetail) {
    _accountList.add(accountDetail);
    notifyListeners();
  }

  void addTransaction(TransactionModel transactionDetail) {
    _transactionList.add(transactionDetail);
    notifyListeners();
  }
}
