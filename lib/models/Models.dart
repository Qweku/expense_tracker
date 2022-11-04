class AccountModel {
  final double? balance;
  final String? accountName;
  List<TransactionModel>? transactions = [];
  AccountModel({this.accountName, this.balance, this.transactions});

  double get remainingBalance {
    double dr = 0;
    double cr = 0;
    for (var element in (transactions ?? [])) {
      if (element.isCredit == false) {
        dr += element.price;
      }
    }
    for (var element in (transactions ?? [])) {
      if (element.isCredit) {
        cr += element.price;
      }
    }
    return (balance ?? 0) + cr - dr;
  }
}

class TransactionModel {
  final bool? isCredit;
  double? price;
  final String? transactionItem, date;
  TransactionModel(
      {this.date, this.price, this.transactionItem, this.isCredit});
}
