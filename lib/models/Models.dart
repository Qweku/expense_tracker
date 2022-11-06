// To parse this JSON data, do
//
//     final accountModel = accountModelFromJson(jsonString);

import 'dart:convert';

List<AccountModel> accountModelFromJson(String str) => List<AccountModel>.from(
    json.decode(str).map((x) => AccountModel.fromJson(x)));

String accountModelToJson(List<AccountModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AccountModel {
  AccountModel({
    this.accountName,
    this.balance,
    this.transactions,
  });

  String? accountName;
  double? balance;
  List<TransactionModel>? transactions=[];

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        accountName: json["accountName"],
        balance: json["balance"],
        transactions: List<TransactionModel>.from(
            json["transactions"].map((x) => TransactionModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "accountName": accountName,
        "balance": balance,
        "transactions":
            List<dynamic>.from(transactions!.map((x) => x.toJson())),
      };

  double get remainingBalance {
    double dr = 0;
    double cr = 0;
    for (var element in (transactions ?? <TransactionModel>[])) {
      if (element.isCredit == 'expense') {
        dr += (element.price ??= 0);
      }
    }
    for (var element in (transactions ?? <TransactionModel>[])) {
      if (element.isCredit == 'income') {
        cr += (element.price ??= 0);
      }
    }
    return (balance ?? 0) + cr - dr;
  }

  double get currentIncome {
    double cr = balance ?? 0;
    for (var element in (transactions ?? <TransactionModel>[])) {
      if (element.isCredit == 'income') {
        cr += (element.price ??= 0);
      }
    }
    return cr;
  }

  double get currentExpense {
    double dr = 0;
    for (var element in (transactions ?? <TransactionModel>[])) {
      if (element.isCredit == 'expense') {
        dr += (element.price ??= 0);
      }
    }
    return dr;
  }
}

class TransactionModel {
  TransactionModel({
    this.transactionItem,
    this.price,
    this.isCredit,
    this.date,
  });

  String? transactionItem;
  double? price;
  String? isCredit;
  String? date;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        transactionItem: json["transactionItem"],
        price: json["price"],
        isCredit: json["isCredit"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "transactionItem": transactionItem,
        "price": price,
        "isCredit": isCredit,
        "date": date,
      };
}
