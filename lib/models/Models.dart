// ignore_for_file: file_names

class AccountModel {
  double? balance;
  final String? accountName;
  List<TransactionModel>? transactions = [];
  AccountModel({this.accountName, this.balance, this.transactions});

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
    double cr = balance??0;
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
  String? isCredit;
  double? price;
  final String? transactionItem, date;
  TransactionModel(
      {this.date, this.price, this.transactionItem, this.isCredit});
}
