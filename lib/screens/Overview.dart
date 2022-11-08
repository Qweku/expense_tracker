// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:async';

import 'package:expense_tracker/components/button_widget.dart';
import 'package:expense_tracker/components/constants.dart';
import 'package:expense_tracker/models/GSheets_API.dart';
import 'package:expense_tracker/models/Models.dart';
import 'package:expense_tracker/models/NotificationModel.dart';
import 'package:expense_tracker/providers/TransactionProvider.dart';
import 'package:expense_tracker/screens/Notification/notificationPlugin.dart';
import 'package:expense_tracker/screens/widgets/cardWidgets.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
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
  bool error = false;
  String expenseOrIncome = 'expense';
  LocalStorage storage = LocalStorage('accounts');
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
    // _addTrxn();
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
                    child: Container(color: Color.fromARGB(255, 238, 238, 238)),
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
                            income: context
                                .watch<TransactionProvider>()
                                .accountList
                                .singleWhere((element) =>
                                    element.accountName ==
                                    widget.accountModel!.accountName!)
                                .currentIncome
                                .toStringAsFixed(2),
                            expense: context
                                .watch<TransactionProvider>()
                                .accountList
                                .singleWhere((element) =>
                                    element.accountName ==
                                    widget.accountModel!.accountName!)
                                .currentExpense
                                .toStringAsFixed(2),
                            balance: context
                                .watch<TransactionProvider>()
                                .accountList
                                .singleWhere((element) =>
                                    element.accountName ==
                                    widget.accountModel!.accountName!)
                                .remainingBalance
                                .toStringAsFixed(2)
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
                                            .read<TransactionProvider>()
                                            .accountList
                                            .singleWhere((element) =>
                                                element.accountName ==
                                                widget
                                                    .accountModel!.accountName)
                                            .transactions![index]
                                            .transactionItem!,
                                        expenseOrIncome: context
                                            .read<TransactionProvider>()
                                            .accountList
                                            .singleWhere((element) =>
                                                element.accountName ==
                                                widget
                                                    .accountModel!.accountName)
                                            .transactions![index]
                                            .isCredit!,
                                        amount: context
                                            .read<TransactionProvider>()
                                            .accountList
                                            .singleWhere((element) =>
                                                element.accountName ==
                                                widget
                                                    .accountModel!.accountName)
                                            .transactions![index]
                                            .price!
                                            .toStringAsFixed(2),
                                            todayDate: context
                                            .read<TransactionProvider>()
                                            .accountList
                                            .singleWhere((element) =>
                                                element.accountName ==
                                                widget
                                                    .accountModel!.accountName)
                                            .transactions![index]
                                            .date!,
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
                  height: height * 0.33,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
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
                        ],
                      ),
                      
                      error
                          ? Text('*Field Required',
                              style: bodyText1.copyWith(
                                  color: Color.fromARGB(255, 252, 17, 0)))
                          : Container(),
                     
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: RadioListTile<Option>(
                              contentPadding: EdgeInsets.zero,
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
                               contentPadding: EdgeInsets.zero,
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
                  Align(
                    alignment: Alignment.center,
                    child: Button(
                      onTap: () async {
                        TransactionModel trxn = TransactionModel(
                            transactionItem: itemName.text,
                            isCredit: expenseOrIncome,
                            date:dateformat.format(DateTime.now()),
                            price: double.tryParse(amount.text));
                        if (itemName.text.isEmpty ||
                            amount.text.isEmpty ||
                            _option == null) {
                          setState(() {
                            error = true;
                          });
                  
                          
                        } else {
                          Provider.of<TransactionProvider>(context, listen: false)
                              .addTransaction(widget.accountModel!, trxn);
                          if (_option == Option.expense) {
                            NotificationModel notiModel = NotificationModel(
                               date: dateformat.format(DateTime.now()),
                              time: timeformat.format(DateTime.now()),
                                title: "Balance Updated",
                                body:
                                    "An expense of ${trxn.price} cedis was deducted. New balance is ${context.read<TransactionProvider>().accountList.singleWhere((element) => element.accountName == widget.accountModel!.accountName!).remainingBalance.toStringAsFixed(2)} cedis.");
                            
                            Provider.of<TransactionProvider>(context,
                                    listen: false)
                                .addNotification(notiModel);
                            
                            await notificationPlugin.showNotification(
                                notiModel.title!, notiModel.body!);
                            
                            await storage.setItem(
                                'notifList',
                                notificationModelToJson(
                                    Provider.of<TransactionProvider>(context,
                                            listen: false)
                                        .notificationList));
                            context.read<TransactionProvider>().notiCount = 1;
                          
                          } else {
                            NotificationModel notiModel = NotificationModel(
                               date: dateformat.format(DateTime.now()),
                              time: timeformat.format(DateTime.now()),
                                title: "Balance Updated",
                                body:
                                    "An income of ${trxn.price} cedis was added. New balance is ${context.read<TransactionProvider>().accountList.singleWhere((element) => element.accountName == widget.accountModel!.accountName!).remainingBalance.toStringAsFixed(2)} cedis.");
                  
                            Provider.of<TransactionProvider>(context,
                                    listen: false)
                                .addNotification(notiModel);
                           
                            await notificationPlugin.showNotification(
                                notiModel.title!, notiModel.body!);
                            
                            await storage.setItem(
                                'notifList',
                                notificationModelToJson(
                                    Provider.of<TransactionProvider>(context,
                                            listen: false)
                                        .notificationList));
                            context.read<TransactionProvider>().notiCount = 1;
                          }
                  
                          await storage.setItem(
                              'accountList',
                              accountModelToJson(Provider.of<TransactionProvider>(
                                      context,
                                      listen: false)
                                  .accountList));
                          startLoading();
                          error = false;
                          itemName.clear();
                          amount.clear();
                  
                          Navigator.pop(context);
                        }
                      },
                      width: width * 0.4,
                      buttonText: 'Add',
                      color: primaryColor,
                    ),
                  )
                ],
              );
            }));
  }
}
