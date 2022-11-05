import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:expense_tracker/components/button_widget.dart';
import 'package:expense_tracker/components/constants.dart';
import 'package:expense_tracker/models/GSheets_API.dart';
import 'package:expense_tracker/models/Models.dart';
import 'package:expense_tracker/providers/TransactionProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../components/textField-widget.dart';

class OverviewScreen extends StatefulWidget {
  //AccountModel accountModel;
  const OverviewScreen({
    super.key,
  });

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  bool isActive = false;
  String expenseOrIncome = '';
  bool timerHasStarted = false;
  TextEditingController itemName = TextEditingController();
  TextEditingController amount = TextEditingController();

  void startLoading() {
    timerHasStarted = true;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
      timer.cancel();
    });
  }

  void _enterTransaction() {
    GSheetsAPI.insert(itemName.text, amount.text, isActive);
  }

  @override
  Widget build(BuildContext context) {
    if (GSheetsAPI.loading == true && timerHasStarted == false) {
      startLoading();
    }

    return WillPopScope(
      onWillPop: () => _backButton(context),
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => _addExpense(context),
            child: const Icon(Icons.add, color: Colors.white),
            backgroundColor: primaryColor,
          ),
          body: SizedBox(
            height: height,
            width: width,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: height * 0.35,
                      width: width,
                      color: primaryColor,
                    ),
                    Expanded(
                      child: Container(color: primaryColorLight),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * 0.15,
                          ),
                          Text("Expenses for",
                              style:
                                  headline1.copyWith(color: primaryColorLight)),
                          Text(
                            GSheetsAPI.worksheet!.title,
                            style: headline2.copyWith(
                              fontSize: 30,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),
                          BalanceCard(
                            income: '${GSheetsAPI.calculateIncome()}',
                            expense: '${GSheetsAPI.calculateExpense()}',
                            balance:
                                '${GSheetsAPI.calculateIncome() - GSheetsAPI.calculateExpense()}',
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: width * 0.01),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Activity',
                              style: headline1.copyWith(color: primaryColor),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                        child: Divider(
                          color: const Color.fromARGB(255, 224, 224, 224),
                          height: height * 0.03,
                        ),
                      ),
                      Expanded(
                        child: GSheetsAPI.loading == true
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                            // : GSheetsAPI.currentTransactions.isEmpty
                            //     ? Center(
                            //         child: Text(
                            //           'No Accounts',
                            //           style: headline1,
                            //         ),
                            //       )
                            : ListView(
                                physics: const BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.01),
                                children: List.generate(
                                    GSheetsAPI.currentTransactions.length,
                                    (index) => TransactionListCard(
                                          title: GSheetsAPI
                                              .currentTransactions[index][0],
                                          expenseOrIncome: GSheetsAPI
                                              .currentTransactions[index][2],
                                          amount: GSheetsAPI
                                              .currentTransactions[index][1],
                                        )),
                              ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  _backButton(context) {
    var theme = Theme.of(context);
    return showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: SizedBox(
                height: height * 0.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning_amber_outlined,
                        size: 40, color: Color.fromARGB(255, 255, 38, 23)),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Do you really want to exit?",
                      style: theme.textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      if (Platform.isIOS) {
                        exit(0);
                      }
                      if (Platform.isAndroid) {
                        return await SystemChannels.platform
                            .invokeMethod<void>('SystemNavigator.pop');
                      }
                    },
                    child: const Text("Yes")),
                TextButton(
                    onPressed: () => Navigator.pop(c, false),
                    child: const Text("No"))
              ],
            ));
  }

  _addExpense(context) {
    var theme = Theme.of(context);
    return showDialog<bool>(
        context: context,
        builder: (c) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                content: SizedBox(
                  height: height * 0.35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Add Transaction',
                          style: theme.textTheme.bodyText1!.copyWith(
                              letterSpacing: 2,
                              fontSize: 20,
                              color: theme.primaryColor)),
                      SizedBox(height: height * 0.01),
                      //Divider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: width * 0.2,
                            child: Divider(color: primaryColor),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: height * 0.01),
                            child: Icon(Icons.edit,
                                color: primaryColorLight, size: 20),
                          ),
                          SizedBox(
                            width: width * 0.2,
                            child: Divider(color: primaryColor),
                          )
                        ],
                      ),

                      SizedBox(height: height * 0.05),
                      CustomTextField(
                        controller: itemName,
                        borderColor: Colors.grey,
                        style: bodyText1,
                        hintText: 'Item',
                        prefixIcon: Icon(
                          Icons.credit_card,
                          color: primaryColorLight,
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      CustomTextField(
                        controller: amount,
                        keyboard: TextInputType.number,
                        borderColor: Colors.grey,
                        hintText: 'Amout',
                        style: bodyText1,
                        prefixIcon: Icon(
                          Icons.monetization_on,
                          color: primaryColorLight,
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Expense',
                            style: bodyText1,
                          ),
                          Switch(
                              activeColor: primaryColor,
                              value: isActive,
                              onChanged: (val) {
                                setState(() {
                                  isActive = val;
                                  if (val) {
                                    expenseOrIncome = 'income';
                                  } else {
                                    expenseOrIncome = 'expense';
                                  }
                                });
                              }),
                          Text(
                            'Income',
                            style: bodyText1,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                actions: [
                  Button(
                    onTap: () {
                      if (itemName.text.isEmpty && amount.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 17, 1),
                              content: Text('Field Required',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyText2),
                              duration: const Duration(milliseconds: 1500),
                              behavior: SnackBarBehavior.floating,
                              shape: const StadiumBorder()),
                        );
                      } else {
                        _enterTransaction();
                        startLoading();
                        Navigator.pop(context);
                      }

                      // TransactionModel trxn = TransactionModel(
                      //     transactionItem: itemName.text,
                      //     isCredit: expenseOrIncome,
                      //     price: double.tryParse(amount.text));
                      // // accountModel.transactions!.add(trxn);
                      // Provider.of<TransactionProvider>(context, listen: false)
                      //     .addTransaction(widget.accountModel, trxn);
                      // widget.accountModel.remainingBalance;
                    },
                    width: width * 0.4,
                    buttonText: 'Add',
                    color: primaryColor,
                  )
                ],
              );
            }));
  }
}

class TransactionListCard extends StatelessWidget {
  const TransactionListCard({
    Key? key,
    required this.title,
    required this.amount,
    required this.expenseOrIncome,
  }) : super(key: key);

  final String title, amount, expenseOrIncome;

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
          title: Text(title, style: headline1.copyWith(fontSize: 17)),
          subtitle: Text(today,
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
                    radius: 30, backgroundColor: primaryColorLight)),
            Positioned(
                bottom: height * 0.02,
                right: width * 0.05,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: primaryColorLight,
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
