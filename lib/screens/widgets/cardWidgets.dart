import 'package:expense_tracker/components/constants.dart';
import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  final String accountName, balance;
  final Function()? onTap, onLongPress;
  const AccountCard({
    Key? key,
    required this.accountName,
    required this.balance,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: height * 0.02),
      child: GestureDetector(
        onLongPress: onLongPress,
        child: ClipRRect(
          //borderRadius: BorderRadius.circular(40),
          child: Container(
            height: height * 0.27,
            width: width * 0.9,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: primaryColorLight),
                color: primaryColor),
            child: Stack(
              children: [
                Positioned(
                    top: height * 0.05,
                    left: width * 0.05,
                    child: CircleAvatar(
                        radius: 30,
                        backgroundColor: primaryColorLight.withOpacity(0.6))),
                Positioned(
                    bottom: height * 0.05,
                    right: width * 0.05,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: primaryColorLight.withOpacity(0.6),
                    )),
                Positioned(
                    height: height * 0.15,
                    right: width * 0.3,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: primaryColorLight.withOpacity(0.6),
                    )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(accountName.toTitleCase(), style: headline2),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Text('Available Balance', style: bodyText2),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('GHS', style: headline2),
                        Text(balance, style: headline2.copyWith(fontSize: 50)),
                        //Text('.50', style: headline2),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Container(
                      width: width * 0.8,
                      //padding: EdgeInsets.symmetric(vertical:height * 0.01),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 194, 194, 194)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                          onPressed: onTap,
                          child: Text('Details',
                              textAlign: TextAlign.center,
                              style: headline2.copyWith(fontSize: 18))),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionListCard extends StatelessWidget {
  const TransactionListCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.expenseOrIncome,
    required this.todayDate,
  }) : super(key: key);

  final String title, amount, expenseOrIncome, todayDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: height * 0.01),
      child: Container(
        padding: EdgeInsets.all(width * 0.01),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white),
            color: //theme.primaryColorLight
                Colors.white.withOpacity(0.5)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              expenseOrIncome == "expense"
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color: expenseOrIncome == "expense"
                  ? primaryColorLight
                  : primaryColor,
            ),
          ),
          title: Text(title.toTitleCase(),
              style: headline1.copyWith(fontSize: 17)),
          subtitle: Text(todayDate,
              style: headline1.copyWith(color: Colors.grey, fontSize: 12)),
          trailing: Text('${expenseOrIncome == 'income' ? '+' : "-"}GHS$amount',
              style: bodyText1.copyWith(fontSize: 17, color: primaryColor)),
        ),
      ),
    );
  }
}

class BalanceCard extends StatelessWidget {
  final String balance, income, expense;
  const BalanceCard({
    Key? key,
    required this.balance,
    required this.income,
    required this.expense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // borderRadius: BorderRadius.circular(40),
      child: Container(
        padding: EdgeInsets.all(width * 0.05),
        height: height * 0.2,
        width: width * 0.9,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: primaryColorLight),
            color: primaryColor),
        child: Stack(
          children: [
            Positioned(
                top: height * 0.02,
                left: width * 0.05,
                child: CircleAvatar(
                    radius: 30,
                    backgroundColor: primaryColorLight.withOpacity(0.6))),
            Positioned(
                bottom: height * 0.02,
                right: width * 0.05,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: primaryColorLight.withOpacity(0.6),
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Available Balance', style: bodyText2),
                SizedBox(
                  height: height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('GHS', style: headline2),
                    Text(balance, style: headline2.copyWith(fontSize: 60)),
                    //Text('.50', style: theme.textTheme.headline2),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.arrow_upward,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(width: width * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Income', style: bodyText2),
                            Text('GHS $income', style: bodyText2),
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Expense', style: bodyText2),
                            Text('GHS $expense', style: bodyText2),
                          ],
                        ),
                        SizedBox(width: width * 0.02),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.arrow_downward,
                            color: primaryColorLight,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
