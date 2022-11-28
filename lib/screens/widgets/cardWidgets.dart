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
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: height * 0.25,
            width: width * 0.9,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // border: Border.all(color: primaryColorLight),
                //color: Colors.white,
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black,
                      primaryColor,
                      //primaryColor
                    ])),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Text(accountName.toTitleCase(), style: headline2),
                    Column(
                      children: [
                        Text('Available Balance', style: bodyText2),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('GHS',
                                style: headline2.copyWith(
                                    color: primaryColorLight)),
                            Text(balance,
                                style: headline2.copyWith(
                                    fontSize: 40, color: primaryColorLight)),
                            //Text('.50', style: headline2),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: width * 0.8,
                      //padding: EdgeInsets.symmetric(vertical:height * 0.01),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                          onPressed: onTap,
                          child: Text('Details',
                              textAlign: TextAlign.center,
                              style: headline2.copyWith(fontSize: 18))),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
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
    this.onTap,
  }) : super(key: key);

  final String title, amount, expenseOrIncome, todayDate;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: height * 0.01),
      child: GestureDetector(
        onTap: onTap,
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
                expenseOrIncome == "debit"
                    ? Icons.arrow_downward
                    : Icons.arrow_upward,
                color: expenseOrIncome == "debit"
                    ? primaryColorLight
                    : primaryColor,
              ),
            ),
            title: Text(title.toTitleCase(),
                style: headline1.copyWith(fontSize: 17)),
            subtitle: Text(todayDate,
                style: headline1.copyWith(color: Colors.grey, fontSize: 12)),
            trailing: Text(
                '${expenseOrIncome == 'credit' ? '+' : "-"}GHS$amount',
                style: bodyText1.copyWith(
                    fontSize: 17,
                    color: expenseOrIncome == 'credit'
                        ? primaryColor
                        : primaryColorLight)),
          ),
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
    return Container(
      padding: EdgeInsets.all(width * 0.05),
      height: height * 0.25,
      width: width * 0.9,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // border: Border.all(color: primaryColorLight),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black,
                primaryColor,
                //primaryColor
              ])),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('Available Balance', style: bodyText2),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('GHS',
                          style: headline2.copyWith(color: primaryColorLight)),
                      Text(balance,
                          style: headline2.copyWith(
                              fontSize: 40, color: primaryColorLight)),
                      //Text('.50', style: theme.textTheme.headline2),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 238, 238, 238),
                        child: Icon(
                          Icons.arrow_upward,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(width: width * 0.02),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Income',
                              style:
                                  bodyText2.copyWith(color: primaryColorLight)),
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
                          Text('Expense',
                              style:
                                  bodyText2.copyWith(color: primaryColorLight)),
                          Text('GHS $expense', style: bodyText2),
                        ],
                      ),
                      SizedBox(width: width * 0.02),
                      CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 238, 238, 238),
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
    );
  }
}
