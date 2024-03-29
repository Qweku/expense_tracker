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
    this.id,
  });

  int? id;
  String? accountName;
  double? balance;
  List<TransactionModel>? transactions = [];

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        id: json["id"],
        accountName: json["accountName"],
        balance: double.tryParse((json["balance"] ?? 0.0).toString()),
        transactions: List<TransactionModel>.from(
            json["transactions"].map((x) => TransactionModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "accountName": accountName,
        "balance": balance ?? 0,
        "transactions": List<dynamic>.from(
            (transactions ??= <TransactionModel>[]).map((x) => x.toJson())),
      };

  double get remainingBalance {
    double dr = 0;
    double cr = 0;
    for (var element in (transactions ?? <TransactionModel>[])) {
      if (element.isCredit == 'debit') {
        dr += (element.price ??= 0);
      }
    }
    for (var element in (transactions ?? <TransactionModel>[])) {
      if (element.isCredit == 'credit') {
        cr += (element.price ??= 0);
      }
    }
    return (balance ?? 0) + cr - dr;
  }

  double get currentIncome {
    double cr = balance ?? 0;
    for (var element in (transactions ?? <TransactionModel>[])) {
      if (element.isCredit == 'credit') {
        cr += (element.price ??= 0);
      }
    }
    return cr;
  }

  double get currentExpense {
    double dr = 0;
    for (var element in (transactions ?? <TransactionModel>[])) {
      if (element.isCredit == 'debit') {
        dr += (element.price ??= 0);
      }
    }
    return dr;
  }
}

class TransactionModel {
  TransactionModel(
      {this.transactionItem, this.price, this.isCredit, this.date, this.id});

  String? transactionItem;
  double? price;
  String? isCredit;
  String? date;
  int? id;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        transactionItem: json["transactionItem"] ?? '',
        price: json["price"] ?? 0,
        isCredit: json["isCredit"] ?? false,
        date: json["date"] ?? '',
        id: json["id"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "transactionItem": transactionItem ?? '',
        "price": price ?? 0,
        "isCredit": isCredit ?? false,
        "date": date ?? '',
        "id": id ?? 0,
      };
}
