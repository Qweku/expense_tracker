// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

// import 'package:expense_tracker/bar_graph/bar_graph.dart';
import 'package:expense_tracker/components/button_widget.dart';
import 'package:expense_tracker/components/constants.dart';
// import 'package:expense_tracker/helper/helper_functions.dart';
import 'package:expense_tracker/models/Models.dart';
// import 'package:expense_tracker/models/NotificationModel.dart';
import 'package:expense_tracker/providers/TransactionProvider.dart';
// import 'package:expense_tracker/screens/Notification/notificationPlugin.dart';
import 'package:expense_tracker/screens/Summary.dart';
import 'package:expense_tracker/screens/widgets/bottom_sheet_widget.dart';
import 'package:expense_tracker/screens/widgets/card_widgets.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

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
  // LocalStorage storage = LocalStorage('accounts');
  bool timerHasStarted = false;
  TextEditingController itemName = TextEditingController();
  TextEditingController amount = TextEditingController();

  //futures to load graph data
  // Future<Map<String, double>>? _monthlyTotalsFuture;
  // Future<double>? _calculateCurrentMonthTotal;

  void refreshGraphData() {
    // _monthlyTotalsFuture =
    //     Provider.of<TransactionProvider>(context, listen: false)
    //         .calculateMonthlyTotals(widget.accountModel!);
    // _calculateCurrentMonthTotal =
    //     Provider.of<TransactionProvider>(context, listen: false)
    //         .calculateCurrentMonthTotal(widget.accountModel!);
  }

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
    refreshGraphData();
    super.initState();
    
    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //   controller.animateTo(controller.position.maxScrollExtent,
    //       duration: const Duration(milliseconds: 10), curve: Curves.easeInOut);
    // });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Consumer<TransactionProvider>(builder: (context, value, child) {
      //get dates
      int startMonth = value.getStartMonth(widget.accountModel!);
      // int startYear = value.getStartYear(widget.accountModel!);
      // int currentMonth = DateTime.now().month;
      // int currentYear = DateTime.now().year;

      log(startMonth.toString());

      //calculate the number of months since the first month
      // int monthCount =
      //     calculateMonthCount(startYear, startMonth, currentYear, currentMonth);

      // List<TransactionModel> currentMonthExpenses =
      //     value.transactionList.where((expense) {
      //   return dateformat.parse(expense.date ?? '').year == currentYear &&
      //       dateformat.parse(expense.date ?? '').month == currentMonth;
      // }).toList();
      return Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButton: FloatingActionButton(
            onPressed: () => _addTrxn(0),
            backgroundColor: theme.colorScheme.inversePrimary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          appBar: AppBar(
            elevation: 0,
            // backgroundColor: primaryColor,
            actions: [
              Padding(
                  padding: EdgeInsets.only(right: width * 0.03),
                  child: IconButton(
                    icon: Icon(
                      Icons.receipt_long,
                      color: theme.colorScheme.inversePrimary,
                      size: 3.0.h,
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
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      Text("Transactions for",
                          style: TextStyle(fontSize: 1.5.h)),
                      Text(
                        widget.accountModel!.accountName!.toTitleCase(),
                        style: TextStyle(
                          fontSize: 3.0.h,
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                     
                      // SizedBox(
                      //   height: 20.h,
                      //   child: FutureBuilder(
                      //       future: _monthlyTotalsFuture,
                      //       builder: (context, snapshot) {
                      //         if (snapshot.connectionState ==
                      //             ConnectionState.done) {
                      //           Map<String, double> monthlyTotals =
                      //               snapshot.data ?? {};

                                

                      //           List<double> monthlySummary =
                      //               List.generate(monthCount, (index) {
                      //             int year = startYear +
                      //                 (startMonth + index - 1) ~/ 12;
                      //             int month = (startMonth + index - 1) % 12 + 1;

                      //             String yearMonthKey = '$year-$month';

                      //              log(monthCount.toString());
                      //               log(yearMonthKey.toString());

                      //             return monthlyTotals[yearMonthKey] ?? 0;
                                  
                      //           });
                      //           log(monthlySummary.first.toString());
                      //           return MyBarGraph(
                      //               monthlySummary: monthlySummary,
                      //               startMonth: startMonth);
                      //         } else {
                      //           return const Center(
                      //             child: Text("Loading..."),
                      //           );
                      //         }
                      //       }),
                      // ),

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
                    height: 5.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.01),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Transaction History',
                          style: TextStyle(fontSize: 1.7.h),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                    child: Divider(
                      color: theme.colorScheme.primary,
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
                                  Icons.no_accounts,
                                  color: theme.colorScheme.primary,
                                  size: 50,
                                ),
                                Text(
                                  'No Transactions',
                                  style: TextStyle(
                                      fontSize: 3.h,
                                      color: theme.colorScheme.primary),
                                ),
                              ],
                            ),
                          )
                        : ListView(
                            controller: controller,
                            physics: const BouncingScrollPhysics(),
                            //reverse: true,
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.01),
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
                                      onTap: () => itemActions(context, index),
                                      title: context
                                          .read<TransactionProvider>()
                                          .accountList
                                          .singleWhere((element) =>
                                              element.accountName ==
                                              widget.accountModel!.accountName)
                                          .transactions![index]
                                          .transactionItem!,
                                      expenseOrIncome: context
                                          .read<TransactionProvider>()
                                          .accountList
                                          .singleWhere((element) =>
                                              element.accountName ==
                                              widget.accountModel!.accountName)
                                          .transactions![index]
                                          .isCredit!,
                                      amount: context
                                          .read<TransactionProvider>()
                                          .accountList
                                          .singleWhere((element) =>
                                              element.accountName ==
                                              widget.accountModel!.accountName)
                                          .transactions![index]
                                          .price!
                                          .toStringAsFixed(2),
                                      todayDate: context
                                          .read<TransactionProvider>()
                                          .accountList
                                          .singleWhere((element) =>
                                              element.accountName ==
                                              widget.accountModel!.accountName)
                                          .transactions![index]
                                          .date!,
                                    )),
                          ),
                  )
                ],
              ),
            ),
          ));
    });
  }

  _addTrxn(int index) {
    return showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (c) => StatefulBuilder(builder: (context, setState) {
              var theme = Theme.of(context);
              return AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 3.w),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                content: SizedBox(
                  height: 40.h,
                  width: 80.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(isEdit ? 'Edit Transaction' : 'Add Transaction',
                              style: TextStyle(
                                letterSpacing: 2,
                                fontSize: 2.0.h,
                              )),
                          SizedBox(height: height * 0.01),
                          //Divider
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: width * 0.2,
                                child:
                                    Divider(color: theme.colorScheme.primary),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: height * 0.01),
                                child: Icon(Icons.edit,
                                    color: theme.colorScheme.tertiary,
                                    size: 20),
                              ),
                              SizedBox(
                                width: width * 0.2,
                                child:
                                    Divider(color: theme.colorScheme.primary),
                              )
                            ],
                          ),
                        ],
                      ),
                      error
                          ? Text('*Field Required',
                              style: bodyText1.copyWith(
                                  color: const Color.fromARGB(255, 252, 17, 0)))
                          : Container(),
                      CustomTextField(
                        controller: itemName,
                        borderColor: theme.colorScheme.primary,
                        hintText: 'Item',
                        prefixIcon: Icon(
                          Icons.credit_card,
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                      CustomTextField(
                        controller: amount,
                        keyboard: TextInputType.number,
                        borderColor: theme.colorScheme.primary,
                        hintText: 'Amount',
                        prefixIcon: Icon(
                          Icons.monetization_on,
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: RadioListTile<Option>(
                              contentPadding: EdgeInsets.zero,
                              activeColor: theme.colorScheme.inversePrimary,
                              title: const Text(
                                'Expense',
                              ),
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
                              activeColor: theme.colorScheme.inversePrimary,
                              title: const Text(
                                'Income',
                              ),
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

                             localStorage.setItem(
                                'accountList',
                                accountModelToJson(
                                    Provider.of<TransactionProvider>(context,
                                            listen: false)
                                        .accountList));
                            startLoading();
                            itemName.clear();
                            amount.clear();
                            error = false;
                            refreshGraphData();

                            Navigator.pop(context);

                            // NotificationModel notiModel = NotificationModel(
                            //     date: dateformat.format(DateTime.now()),
                            //     time: timeformat.format(DateTime.now()),
                            //     title: "Balance Updated",
                            //     body:
                            //         "Your account has been debited ${trxn.price} cedis. New balance is ${context.read<TransactionProvider>().accountList.singleWhere((element) => element.accountName == widget.accountModel!.accountName!).remainingBalance.toStringAsFixed(2)} cedis.");

                            // Provider.of<TransactionProvider>(context,
                            //         listen: false)
                            //     .addNotification(notiModel);

                            // await notificationPlugin.showNotification(
                            //     notiModel.title!, notiModel.body!);

                            // await storage.setItem(
                            //     'notifList',
                            //     notificationModelToJson(
                            //         Provider.of<TransactionProvider>(context,
                            //                 listen: false)
                            //             .notificationList));
                            // context.read<TransactionProvider>().notiCount = 1;
                          } else if (_option == Option.income && !isEdit) {
                            Provider.of<TransactionProvider>(context,
                                    listen: false)
                                .addTransaction(widget.accountModel!, trxn);

                            localStorage.setItem(
                                'accountList',
                                accountModelToJson(
                                    Provider.of<TransactionProvider>(context,
                                            listen: false)
                                        .accountList));
                            startLoading();

                            itemName.clear();
                            amount.clear();
                            error = false;
                            refreshGraphData();

                            Navigator.pop(context);

                            // NotificationModel notiModel = NotificationModel(
                            //     date: dateformat.format(DateTime.now()),
                            //     time: timeformat.format(DateTime.now()),
                            //     title: "Balance Updated",
                            //     body:
                            //         "Your account has been credited ${trxn.price} cedis. New balance is ${context.read<TransactionProvider>().accountList.singleWhere((element) => element.accountName == widget.accountModel!.accountName!).remainingBalance.toStringAsFixed(2)} cedis.");

                            // Provider.of<TransactionProvider>(context,
                            //         listen: false)
                            //     .addNotification(notiModel);

                            // await notificationPlugin.showNotification(
                            //     notiModel.title!, notiModel.body!);

                            // await storage.setItem(
                            //     'notifList',
                            //     notificationModelToJson(
                            //         Provider.of<TransactionProvider>(context,
                            //                 listen: false)
                            //             .notificationList));
                            // context.read<TransactionProvider>().notiCount = 1;
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
                            refreshGraphData();
                          }

                          // await storage.setItem(
                          //     'accountList',
                          //     accountModelToJson(
                          //         Provider.of<TransactionProvider>(context,
                          //                 listen: false)
                          //             .accountList));
                          // startLoading();
                          // error = false;
                          // itemName.clear();
                          // amount.clear();

                          // Navigator.pop(context);
                          // SchedulerBinding.instance
                          //     .addPostFrameCallback((timeStamp) {
                          //   controller.animateTo(
                          //       controller.position.maxScrollExtent,
                          //       duration: const Duration(milliseconds: 10),
                          //       curve: Curves.easeInOut);
                          // });
                        }
                      },
                      width: 100.w,
                      buttonText: isEdit ? 'Done' : 'Add',
                      color: theme.colorScheme.inversePrimary,
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
        //backgroundColor: Colors.grey[900],
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
                        refreshGraphData();
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
