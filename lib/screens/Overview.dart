// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:expense_tracker/components/button_widget.dart';
import 'package:expense_tracker/components/constants.dart';
import 'package:expense_tracker/models/GSheets_API.dart';
import 'package:expense_tracker/models/Models.dart';
import 'package:expense_tracker/models/NotificationModel.dart';
import 'package:expense_tracker/providers/TransactionProvider.dart';
import 'package:expense_tracker/screens/Notification/notificationPlugin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/textField-widget.dart';

enum Option { expense, income }

class OverviewScreen extends StatefulWidget {
  AccountModel? accountModel;
  OverviewScreen({
    this.accountModel,
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

  Option? _option = Option.expense;

  @override
  void initState() {
    _addTrxn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (GSheetsAPI.loading == true && timerHasStarted == false) {
      startLoading();
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addTrxn(),
          backgroundColor: primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
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
                          widget.accountModel!.accountName!.toTitleCase(),
                          style: headline2.copyWith(
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.05,
                        ),
                        BalanceCard(
                          income:
                              '${context.watch<TransactionProvider>().accountList.singleWhere((element) => element.accountName == widget.accountModel!.accountName!).currentIncome}',
                          expense:
                              '${context.watch<TransactionProvider>().accountList.singleWhere((element) => element.accountName == widget.accountModel!.accountName!).currentExpense}',
                          balance:
                              '${context.watch<TransactionProvider>().accountList.singleWhere((element) => element.accountName == widget.accountModel!.accountName!).remainingBalance}',
                          //'${widget.accountModel!.remainingBalance}',
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
                      child: (context
                                  .watch<TransactionProvider>()
                                  .accountList
                                  .singleWhere((element) =>
                                      element.accountName ==
                                      widget.accountModel!.accountName)
                                  .transactions ??= [])
                              .isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.mood_bad,
                                    color: primaryColor,
                                    size: 50,
                                  ),
                                  Text(
                                    'No Transactions',
                                    style: headline1,
                                  ),
                                ],
                              ),
                            )
                          : ListView(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.01),
                              children: List.generate(
                                  (context
                                          .watch<TransactionProvider>()
                                          .accountList
                                          .singleWhere((element) =>
                                              element.accountName ==
                                              widget.accountModel!.accountName)
                                          .transactions ??= [])
                                      .length,
                                  (index) => TransactionListCard(
                                        title: context
                                            .watch<TransactionProvider>()
                                            .accountList
                                            .singleWhere((element) =>
                                                element.accountName ==
                                                widget
                                                    .accountModel!.accountName)
                                            .transactions![index]
                                            .transactionItem!,
                                        expenseOrIncome: context
                                            .watch<TransactionProvider>()
                                            .accountList
                                            .singleWhere((element) =>
                                                element.accountName ==
                                                widget
                                                    .accountModel!.accountName)
                                            .transactions![index]
                                            .isCredit!,
                                        amount:
                                            '${context.watch<TransactionProvider>().accountList.singleWhere((element) => element.accountName == widget.accountModel!.accountName).transactions![index].price!}',
                                      )),
                            ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  _addTrxn() async {
    await Future.delayed(const Duration(milliseconds: 100));

    return showDialog<bool>(
        barrierDismissible: false,
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
                          style: bodyText1.copyWith(
                              letterSpacing: 2,
                              fontSize: 20,
                              color: primaryColor)),
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
                        hintText: 'Amount',
                        style: bodyText1,
                        prefixIcon: Icon(
                          Icons.monetization_on,
                          color: primaryColorLight,
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: RadioListTile<Option>(
                              activeColor: primaryColor,
                              title: Text('Expense', style: bodyText1),
                              value: Option.expense,
                              groupValue: _option,
                              onChanged: (Option? value) {
                                setState(() {
                                  _option = value;
                                  expenseOrIncome = 'expense';
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<Option>(
                              activeColor: primaryColor,
                              title: Text('Income', style: bodyText1),
                              value: Option.income,
                              groupValue: _option,
                              onChanged: (Option? value) {
                                setState(() {
                                  _option = value;
                                  expenseOrIncome = 'income';
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                actions: [
                  Button(
                    onTap: () async {
                      TransactionModel trxn = TransactionModel(
                          transactionItem: itemName.text,
                          isCredit: expenseOrIncome,
                          price: double.tryParse(amount.text));
                      NotificationModel notiModel = NotificationModel(
                          title: "Balance Updated",
                          body:
                              "An income of 200 cedis was added. New balance is 3000");
                      if (itemName.text.isEmpty &&
                          amount.text.isEmpty &&
                          _option == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 17, 1),
                              content: Text('Field Required',
                                  textAlign: TextAlign.center,
                                  style: bodyText2),
                              duration: const Duration(milliseconds: 1500),
                              behavior: SnackBarBehavior.floating,
                              shape: const StadiumBorder()),
                        );
                      } else {
                        Provider.of<TransactionProvider>(context, listen: false)
                            .addTransaction(widget.accountModel!, trxn);
                        if (trxn.isCredit == 'expense') {
                          NotificationModel notiModel = NotificationModel(
                              title: "Balance Updated",
                              body:
                                  "An expense of ${trxn.price} cedis was deducted. New balance is ${context.read<TransactionProvider>().accountList.singleWhere((element) => element.accountName == widget.accountModel!.accountName!).remainingBalance}");
                          Provider.of<TransactionProvider>(context,
                                  listen: false)
                              .addNotification(notiModel);
                          await notificationPlugin.showNotification(
                              notiModel.title!,
                              notiModel.body!);
                        }else{
                          NotificationModel notiModel = NotificationModel(
                              title: "Balance Updated",
                              body:
                                  "An income of ${trxn.price} cedis was added. New balance is ${context.read<TransactionProvider>().accountList.singleWhere((element) => element.accountName == widget.accountModel!.accountName!).remainingBalance}");
                          Provider.of<TransactionProvider>(context,
                                  listen: false)
                              .addNotification(notiModel);
                          await notificationPlugin.showNotification(
                              notiModel.title!,
                              notiModel.body!);
                        }

                        startLoading();
                        Navigator.pop(context);
                      }
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
          title: Text(title.toTitleCase(),
              style: headline1.copyWith(fontSize: 17)),
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
