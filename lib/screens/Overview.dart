// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:async';

import 'package:expense_tracker/components/button_widget.dart';
import 'package:expense_tracker/components/constants.dart';
import 'package:expense_tracker/models/GSheets_API.dart';
import 'package:expense_tracker/models/Models.dart';
import 'package:expense_tracker/models/NotificationModel.dart';
import 'package:expense_tracker/providers/TransactionProvider.dart';
import 'package:expense_tracker/screens/Notification/notificationPlugin.dart';
import 'package:expense_tracker/screens/Summary.dart';
import 'package:expense_tracker/screens/widgets/bottomSheetWidget.dart';
import 'package:expense_tracker/screens/widgets/cardWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  bool isEdit = false;
  String expenseOrIncome = 'debit';
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
  ScrollController controller = ScrollController();

  Option? _option = Option.expense;

  @override
  void initState() {
    // _addTrxn();
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      controller.animateTo(controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 10), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (GSheetsAPI.loading == true && timerHasStarted == false) {
      startLoading();
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addTrxn(0),
          backgroundColor: primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          actions: [
            Padding(
                padding: EdgeInsets.only(right: width * 0.03),
                child: IconButton(
                  icon: Icon(
                    Icons.receipt_long,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SummaryScreen(
                                accountModel: widget.accountModel!)));
                  },
                ))
          ],
        ),
        body: SizedBox(
          height: height,
          width: width,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: height * 0.3,
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
                          height: height * 0.07,
                        ),
                        Text("Transactions for",
                            style:
                                headline1.copyWith(color: primaryColorLight)),
                        Text(
                          widget.accountModel!.accountName!.toTitleCase(),
                          style: headline2.copyWith(
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
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
                            controller: controller,
                              physics: const BouncingScrollPhysics(),
                              reverse: true,
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
                                        onTap: () =>
                                            itemActions(context, index),
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

  _addTrxn(int index) async {
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(isEdit ? 'Edit Transaction' : 'Add Transaction',
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: height * 0.01),
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
                                  expenseOrIncome = 'debit';
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
                                  expenseOrIncome = 'credit';
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
                            id: Provider.of<TransactionProvider>(context,
                                        listen: false)
                                    .accountList[index]
                                    .transactions!
                                    .length +
                                1,
                            transactionItem: itemName.text,
                            isCredit: expenseOrIncome,
                            date: dateformat.format(DateTime.now()),
                            price: double.tryParse(amount.text));
                        if (itemName.text.isEmpty ||
                            amount.text.isEmpty ||
                            _option == null) {
                          setState(() {
                            error = true;
                          });
                        } else {
                          if (_option == Option.expense && !isEdit) {
                            Provider.of<TransactionProvider>(context,
                                    listen: false)
                                .addTransaction(widget.accountModel!, trxn);

                            NotificationModel notiModel = NotificationModel(
                                date: dateformat.format(DateTime.now()),
                                time: timeformat.format(DateTime.now()),
                                title: "Balance Updated",
                                body:
                                    "Your account has been debited ${trxn.price} cedis. New balance is ${context.read<TransactionProvider>().accountList.singleWhere((element) => element.accountName == widget.accountModel!.accountName!).remainingBalance.toStringAsFixed(2)} cedis.");

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
                          } else if (_option == Option.income && !isEdit) {
                            Provider.of<TransactionProvider>(context,
                                    listen: false)
                                .addTransaction(widget.accountModel!, trxn);

                            NotificationModel notiModel = NotificationModel(
                                date: dateformat.format(DateTime.now()),
                                time: timeformat.format(DateTime.now()),
                                title: "Balance Updated",
                                body:
                                    "Your account has been credited ${trxn.price} cedis. New balance is ${context.read<TransactionProvider>().accountList.singleWhere((element) => element.accountName == widget.accountModel!.accountName!).remainingBalance.toStringAsFixed(2)} cedis.");

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
                          } else if (isEdit &&
                              Provider.of<TransactionProvider>(context,
                                          listen: false)
                                      .accountList[index]
                                      .transactions![index]
                                      .id ==
                                  index + 1) {
                            TransactionModel trxnModel = TransactionModel(
                                id: Provider.of<TransactionProvider>(context,
                                        listen: false)
                                    .accountList[index]
                                    .transactions![index]
                                    .id,
                                transactionItem: itemName.text,
                                price: double.tryParse(amount.text),
                                isCredit: expenseOrIncome);

                            Provider.of<TransactionProvider>(context,
                                    listen: false)
                                .editTransaction(
                                    widget.accountModel!, trxnModel);
                            isEdit = false;
                          }

                          await storage.setItem(
                              'accountList',
                              accountModelToJson(
                                  Provider.of<TransactionProvider>(context,
                                          listen: false)
                                      .accountList));
                          startLoading();
                          error = false;
                          itemName.clear();
                          amount.clear();
                          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      controller.animateTo(controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 10), curve: Curves.easeInOut);
    });

                          Navigator.pop(context);
                        }
                      },
                      width: width * 0.4,
                      buttonText: isEdit ? 'Done' : 'Add',
                      color: primaryColor,
                    ),
                  )
                ],
              );
            }));
  }

  void itemActions(context, int index) {
    final theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        backgroundColor: Colors.grey[900],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            spacing: 20,
            children: <Widget>[
              SizedBox(height: height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BottomSheetChild(
                      onTap: () {
                        setState(() {
                          if (Provider.of<TransactionProvider>(context,
                                      listen: false)
                                  .accountList[index]
                                  .transactions![index]
                                  .id ==
                              index + 1) {
                            itemName.text = Provider.of<TransactionProvider>(
                                    context,
                                    listen: false)
                                .accountList[index]
                                .transactions![index]
                                .transactionItem!;
                            amount.text = Provider.of<TransactionProvider>(
                                    context,
                                    listen: false)
                                .accountList[index]
                                .transactions![index]
                                .price!
                                .toString();
                          }
                        });
                        isEdit = true;
                        _addTrxn(index);
                        Navigator.pop(context);
                      },
                      theme: theme,
                      title: 'Edit',
                      icon: Icons.edit),
                  BottomSheetChild(
                      onTap: () async {
                        Provider.of<TransactionProvider>(context, listen: false)
                            .removeTransaction(index, widget.accountModel!);
                        Navigator.pop(context);
                      },
                      theme: theme,
                      title: 'Delete',
                      icon: Icons.delete)
                ],
              ),
              SizedBox(height: height * 0.05),
            ],
          );
        });
  }
}
