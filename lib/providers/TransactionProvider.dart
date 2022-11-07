// ignore_for_file: file_names

import 'package:expense_tracker/models/Models.dart';
import 'package:expense_tracker/models/NotificationModel.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class TransactionProvider with ChangeNotifier {
  LocalStorage storage = LocalStorage('accountList');
  int _notiCount = 0;
  List<NotificationModel> _notificationList = [];
  List<AccountModel> _accountList = [];
  List<TransactionModel> _transactionList = [];

  int get notiCount => _notiCount;
  List<AccountModel> get accountList => _accountList;
  List<TransactionModel> get transactionList => _transactionList;
  List<NotificationModel> get notificationList => _notificationList;

  set accountList(List<AccountModel> accountList) {
    _accountList = accountList;
    notifyListeners();
  }

  set notiCount(int notiCount) {
    _notiCount = notiCount;
    notifyListeners();
  }

  set notificationList(List<NotificationModel> notificationList) {
    _notificationList = notificationList;
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

  void addNotification(NotificationModel notificationModel) {
    _notificationList.add(notificationModel);
  }

  void removeAccount(AccountModel accountModel) {
    for (var element in _accountList) {
      if (element.accountName == accountModel.accountName) {
        storage.deleteItem('accountList');
      }
    }
    notifyListeners();
  }
}
