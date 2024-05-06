import 'package:expense_tracker/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
    var theme = Theme.of(context);
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
              color: theme.colorScheme.tertiary,
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      accountName.toTitleCase(),
                      style: TextStyle(fontSize: 2.5.h),
                    ),
                    Column(
                      children: [
                        const Text(
                          'Available Balance',
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'GHS',
                            ),
                            Text(balance, style: TextStyle(fontSize: 4.0.h)),
                            //Text('.50', style: headline2),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: width * 0.8,
                      //padding: EdgeInsets.symmetric(vertical:height * 0.01),
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.colorScheme.secondary),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                          onPressed: onTap,
                          child: Text('Details',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 1.8.h,
                                  color: theme.colorScheme.secondary))),
                    ),
                    SizedBox(
                      height: 1.h,
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

  final String title, amount, expenseOrIncome;
  final String todayDate;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var theme=Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: height * 0.01),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(width * 0.01),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: theme.colorScheme.primary),
              color: //theme.primaryColorLight
                  theme.colorScheme.primary.withOpacity(0.5)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.tertiary,
              child: Icon(
                expenseOrIncome == "debit"
                    ? Icons.arrow_downward
                    : Icons.arrow_upward,
                color: expenseOrIncome == "debit"
                    ? theme.colorScheme.primary
                    : theme.colorScheme.inversePrimary,
              ),
            ),
            title: Text(title.toTitleCase(),
                style: TextStyle(fontSize: 1.7.h)),
            subtitle: Text(todayDate,
                style: TextStyle(color: theme.colorScheme.inversePrimary, fontSize: 1.2.h)),
            trailing: Text(
                '${expenseOrIncome == 'credit' ? '+' : "-"}GHS$amount',
                style:TextStyle(
                    fontSize: 1.7.h,
                    color: theme.colorScheme.inversePrimary
                    )),
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
    var theme=Theme.of(context);
    return Container(
      padding: EdgeInsets.all(width * 0.05),
      height: height * 0.25,
      width: width * 0.9,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // border: Border.all(color: primaryColorLight),
          color: theme.colorScheme.tertiary
         ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('Available Balance', style: TextStyle(fontSize: 1.7.h)),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('GHS',
                          ),
                      Text(balance,
                          style: TextStyle(
                              fontSize: 4.0.h,)),
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
                        backgroundColor: theme.colorScheme.primary,
                        child: Icon(
                          Icons.arrow_upward,
                          color: theme.colorScheme.inversePrimary,
                        ),
                      ),
                      SizedBox(width: width * 0.02),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Income',
                              style:
                                  TextStyle(fontSize: 1.2.h)),
                          Text('GHS $income', style: TextStyle(fontSize: 1.4.h)),
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
                                  TextStyle(fontSize: 1.2.h)),
                          Text('GHS $expense', style: TextStyle(fontSize: 1.4.h)),
                        ],
                      ),
                      SizedBox(width: width * 0.02),
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.primary,
                        child: Icon(
                          Icons.arrow_downward,
                          color: theme.colorScheme.inversePrimary,
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
