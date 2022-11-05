// ignore_for_file: file_names

class AccountModel {
  final double? balance;
  final String? accountName;
  List<TransactionModel>? transactions = [];
  AccountModel({this.accountName, this.balance, this.transactions});

  double get remainingBalance {
    double dr = 0;
    double cr = 0;
    for (var element in (transactions ?? <TransactionModel>[])) {
      if (element.isCredit == false) {
        dr += (element.price ??= 0);
      }
    }
    for (var element in (transactions ?? <TransactionModel>[])) {
      if (element.isCredit == true) {
        cr += (element.price ??= 0);
      }
    }
    return (balance ?? 0) + cr - dr;
  }

  toJSONEncodable() {
    Map<String, dynamic> accItem = {};
    accItem['accountName'] = accountName;
    accItem['balance'] = balance;
    accItem['transactions'] = 
    transactions!.map((e) {
      return e.toJSONEncodable();
    }).toList();

    return accItem;
  }
}

class TransactionModel {
  final String? isCredit;
  double? price;
  final String? transactionItem, date;
  TransactionModel(
      {this.date, this.price, this.transactionItem, this.isCredit});

  toJSONEncodable() {
    Map<String, dynamic> trxnItem = {};
    trxnItem['isCredit'] = isCredit;
    trxnItem['price'] = price;
    trxnItem['transactionItem'] = transactionItem;

    return trxnItem;
  }
}
