// ignore_for_file: file_names

import 'package:expense_tracker/models/Models.dart';
import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';

class TransactionProvider with ChangeNotifier {
  LocalStorage storage = LocalStorage('acc');
  List<AccountModel> _accountList = [];
  List<TransactionModel> _transactionList = [];

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

  void addTransaction(
      AccountModel accountModel, TransactionModel transactionModel) {
    for (var element in _accountList) {
      if (element.accountName == accountModel.accountName) {
        (element.transactions ??= []).add(transactionModel);
      }
    }
    notifyListeners();
  }

  
}
