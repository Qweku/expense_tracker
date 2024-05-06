// ignore_for_file: file_names
import 'package:expense_tracker/components/constants.dart';
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
  List<TransactionModel> _filteredTransactions = [];
  bool isFiltered = false;

  int get notiCount => _notiCount;
  List<AccountModel> get accountList => _accountList;
  List<TransactionModel> get transactionList => _transactionList;
  List<TransactionModel> get filteredTransactions => _filteredTransactions;
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

  void editAccount(AccountModel accountModel) {
    for (var element in _accountList) {
      if (element.id == accountModel.id) {
        element.accountName = accountModel.accountName;
        element.balance = accountModel.balance;
      }
    }
    notifyListeners();
  }

  void editTransaction(
      AccountModel accountModel, TransactionModel transactionModel) {
    for (var element in _accountList) {
      if (element.accountName == accountModel.accountName) {
        element.transactions!
            .singleWhere((element) => element.id == transactionModel.id)
            .transactionItem = transactionModel.transactionItem;
        element.transactions!
            .singleWhere((element) => element.id == transactionModel.id)
            .price = transactionModel.price;
        element.transactions!
            .singleWhere((element) => element.id == transactionModel.id)
            .isCredit = transactionModel.isCredit;
      }
    }
    notifyListeners();
  }

  void addNotification(NotificationModel notificationModel) {
    _notificationList.add(notificationModel);
  }

  void removeAccount(int index) {
    _accountList.removeAt(index);
    notifyListeners();
  }

  void removeTransaction(int index, AccountModel accountModel) {
    for (var element in _accountList) {
      if (element.accountName == accountModel.accountName) {
        (element.transactions ??= []).removeAt(index);
      }
    }
    notifyListeners();
  }

  void filter(DateTime from, DateTime to, AccountModel accountModel) {
    _filteredTransactions.clear();
    for (TransactionModel transaction
        in (accountModel.transactions ?? <TransactionModel>[])) {
      if (dateformat.parse(transaction.date!).isBefore(from) ||
          dateformat.parse(transaction.date!).isAfter(to)) {
        continue;
      }
      _filteredTransactions.add(transaction);
    }
    isFiltered = true;
    notifyListeners();
  }

  //calculate total expense for each month
  Future<Map<String, double>> calculateMonthlyTotals( AccountModel accountModel) async {
    

    Map<String, double> monthlyTotals = {};

    for (TransactionModel transaction
        in (accountModel.transactions ?? <TransactionModel>[])) {
      //extract the month from the date of the expense
      String yearMonth = '${dateformat.parse(transaction.date?? '').year}-${dateformat.parse(transaction.date?? '').month}';

      //If the month is not yet in the map initialize to 0
      if (!monthlyTotals.containsKey(yearMonth)) {
        monthlyTotals[yearMonth] = 0;
      }

      monthlyTotals[yearMonth] = monthlyTotals[yearMonth]! + transaction.price!;
    }
     
    return monthlyTotals;
    
  }

// claculate current month total
  Future<double> calculateCurrentMonthTotal(AccountModel accountModel) async {
   

    int currentMonth = DateTime.now().month;
    int currentYear = DateTime.now().year;

    List<TransactionModel> currentMonthExpenses = accountModel.transactions??<TransactionModel>[].where((expense) {
      return dateformat.parse(expense.date?? '').month == currentMonth &&
          dateformat.parse(expense.date?? '').year == currentYear;
    }).toList();

    double total =
        currentMonthExpenses.fold(0, (sum, expense) => sum + expense.price!);

    return total;
  }

  int getStartMonth(AccountModel accountModel) {
    if (accountModel.transactions == null) {
      return DateTime.now().month;
    }

    accountModel.transactions??<TransactionModel>[].sort((a, b) => a.date!.compareTo(b.date!));

    return dateformat.parse(accountModel.transactions!.first.date ?? "").month;
  }

  int getStartYear(AccountModel accountModel) {
    if (accountModel.transactions==null) {
      return DateTime.now().year;
    }

    accountModel.transactions??<TransactionModel>[].sort((a, b) => a.date!.compareTo(b.date!));

    return dateformat.parse(accountModel.transactions!.first.date ?? "").year;
  }

}
