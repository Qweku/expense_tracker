import 'dart:io';

import 'package:expense_tracker/components/constants.dart';
import 'package:expense_tracker/components/textField-widget.dart';
import 'package:expense_tracker/models/Models.dart';
import 'package:expense_tracker/providers/TransactionProvider.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class SummaryScreen extends StatefulWidget {
  final AccountModel accountModel;
  const SummaryScreen({super.key, required this.accountModel});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  late Uint8List _imageFile;
  DateTime? startDate;
  DateTime? endDate;
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2022, 8, 23),
    end: DateTime(2022, 10, 23),
  );

  Future filterDate() async {
    DateTimeRange? newRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (newRange == null) return;
    // setState(() {
    dateRange = newRange;
    fromDate.text = dateformat.format(dateRange.start);
    toDate.text = dateformat.format(dateRange.end);
    // });
    filter(dateRange.start, dateRange.end);
    // print(isFiltered);
  }

  shareImage() async {
    String tempPath = (await getApplicationDocumentsDirectory()).path;
    String fileName = "TransactionFile";
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    _imageFile = (await screenshotController.capture())!;

    if (await Permission.storage.request().isGranted) {
      File file = await File('$tempPath/$fileName.png');
      file.writeAsBytesSync(_imageFile);
      await Share.shareFiles([file.path]);
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text("Share result: ${file}"),
      ));
    }
  }

  Future getPdf() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final screenShot = (await screenshotController.capture())!;
    pw.Document pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Expanded(
              child:
                  pw.Image(pw.MemoryImage(screenShot), fit: pw.BoxFit.contain));
        },
      ),
    );
    String tempPath = (await getApplicationDocumentsDirectory()).path;
    String fileName = "mytransactionFile";
    if (await Permission.storage.request().isGranted) {
      File pdfFile = File('$tempPath/$fileName.pdf');
      pdfFile.writeAsBytes(await pdf.save());
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text("File Saved: $pdfFile"),
      ));
    }
  }

  List<TransactionModel> filteredTransactions = [];
  bool isFiltered = false;
  void filter(DateTime from, DateTime to) {
    filteredTransactions.clear();
    for (TransactionModel transaction
        in (widget.accountModel.transactions ?? <TransactionModel>[])) {
      if (dateformat.parse(transaction.date ?? '').isBefore(from) ||
          dateformat.parse(transaction.date ?? '').isAfter(to)) {
        continue;
      }
      filteredTransactions.add(transaction);
    }
    setState(() {
      isFiltered = true;
    });

    return;
  }

  double netIncome() {
    double income = 0;
    for (var element
        in (Provider.of<TransactionProvider>(context, listen: false)
            .filteredTransactions)) {
      if (element.isCredit == 'credit') {
        income += (element.price ??= 0);
      }
    }
    return income;
  }

  double netExpense() {
    double expense = 0;
    for (var element
        in (Provider.of<TransactionProvider>(context, listen: false)
            .filteredTransactions)) {
      if (element.isCredit == 'debit') {
        expense += (element.price ??= 0);
      }
    }
    return expense;
  }

  @override
  Widget build(BuildContext context) {
    final difference = dateRange.duration.inDays;
    final List<DateTime> filteredDates =
        List<DateTime>.generate(difference, (index) {
      DateTime date = dateRange.start;

      return date.add(Duration(days: index));
    });
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryColor,
        // floatingActionButton:
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     FloatingActionButton(
        //       onPressed: () => shareImage(),
        //       backgroundColor: primaryColorLight,
        //       child: const Icon(Icons.share, color: Colors.white),
        //     ),
        //     SizedBox(height: height * 0.02),
        //     FloatingActionButton(
        //       onPressed: getPdf,
        //       backgroundColor: primaryColorLight,
        //       child: const Icon(Icons.save_alt, color: Colors.white),
        //     ),
        //   ],
        // ),
        body: SizedBox(
          height: height,
          width: width,
          child: SafeArea(
              child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(width * 0.05),
                    child: Row(
                      children: [
                        Expanded(
                          child: DateTextField(
                            controller: fromDate,
                            color: Colors.white,
                            style: bodyText1,
                            hintText: 'From',
                            onChanged: (p0) {
                              if (p0 != null && toDate.text.isNotEmpty) {
                                filter(
                                  p0,
                                  dateformat.parse(toDate.text),
                                );
                                print(p0);
                              } else {
                                setState(() {
                                  isFiltered = false;
                                });
                              }
                              // print(isFiltered);
                            },
                            prefixIcon: Icon(Icons.calendar_today,
                                color: primaryColorLight, size: 15),
                          ),
                        ),
                        SizedBox(width: width * 0.01),
                        CircleAvatar(
                            backgroundColor: primaryColorLight,
                            child: IconButton(
                                onPressed: () {
                                  filterDate();
                                },
                                icon: Icon(Icons.filter_alt,
                                    color: Colors.white))),
                        SizedBox(width: width * 0.01),
                        Expanded(
                          child: DateTextField(
                            controller: toDate,
                            color: Colors.white,
                            style: bodyText1,
                            hintText: 'To',
                            onChanged: (p0) {
                              if (p0 != null && fromDate.text.isNotEmpty) {
                                filter(
                                  dateformat.parse(fromDate.text),
                                  p0,
                                );
                                print(p0);
                              } else {
                                setState(() {
                                  isFiltered = false;
                                });
                              }
                              // print(isFiltered);
                            },
                            prefixIcon: Icon(Icons.calendar_today,
                                color: primaryColorLight, size: 15),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Screenshot(
                      controller: screenshotController,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(width * 0.03),
                                  child: Text(
                                      "${dateformat.format(DateTime.now())},  ${timeformat.format(DateTime.now())}")),
                              Padding(
                                padding: EdgeInsets.all(width * 0.05),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          widget.accountModel.accountName!
                                              .toTitleCase(),
                                          style:
                                              headline1.copyWith(fontSize: 20)),
                                      Image.asset(
                                        'assets/app-logo.png',
                                        width: width * 0.15,
                                      ),
                                    ]),
                              ),
                              SizedBox(height: height * 0.03),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.05),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text('Transactions',
                                          style: headline1),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Total Credit:',
                                                  style: bodyText1.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  isFiltered
                                                      ? 'GHS ${netIncome()}'
                                                      : 'GHS ${context.watch<TransactionProvider>().accountList.singleWhere((element) => element.accountName == widget.accountModel.accountName!).currentIncome.toStringAsFixed(2)}',
                                                  style: bodyText1),
                                            ],
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Total Debit:',
                                                  style: bodyText1.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                isFiltered
                                                    ? 'GHS ${netExpense()}'
                                                    : 'GHS ${context.watch<TransactionProvider>().accountList.singleWhere((element) => element.accountName == widget.accountModel.accountName!).currentExpense.toStringAsFixed(2)}',
                                                style: bodyText1,
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Total Balance:',
                                                  style: bodyText1.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  'GHS ${context.watch<TransactionProvider>().accountList.singleWhere((element) => element.accountName == widget.accountModel.accountName!).remainingBalance.toStringAsFixed(2)}',
                                                  style: bodyText1),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: height * 0.05),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: height * 0.01,
                                    horizontal: width * 0.05),
                                color: Color.fromARGB(255, 197, 196, 196),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Text('Items',
                                            style: bodyText1.copyWith(
                                                fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: Text('Date',
                                            style: bodyText1.copyWith(
                                                fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: Text('Transaction Type',
                                            style: bodyText1.copyWith(
                                                fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: Text('Amount',
                                            textAlign: TextAlign.right,
                                            style: bodyText1.copyWith(
                                                fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(width * 0.05),
                                child: SizedBox(
                                    // height: height * 0.7,
                                    child: (context
                                                .watch<TransactionProvider>()
                                                .accountList
                                                .singleWhere((element) =>
                                                    element.accountName ==
                                                    widget.accountModel
                                                        .accountName)
                                                .transactions ??= [])
                                            .isEmpty
                                        ? Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                        : isFiltered
                                            ? filteredTransactions.isEmpty
                                                ? Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.mood_bad,
                                                          color: primaryColor,
                                                          size: 50,
                                                        ),
                                                        Text(
                                                          'No Transactions Range',
                                                          style: headline1,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : ListView(
                                                  reverse: true,
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    children: List.generate(
                                                        filteredTransactions
                                                            .length,
                                                        (index) =>
                                                            SummaryListItem(
                                                              item: filteredTransactions[
                                                                      index]
                                                                  .transactionItem!,
                                                              date:
                                                                  filteredTransactions[
                                                                          index]
                                                                      .date!,
                                                              transactionType:
                                                                  filteredTransactions[
                                                                          index]
                                                                      .isCredit!,
                                                              amount: filteredTransactions[
                                                                      index]
                                                                  .price!
                                                                  .toStringAsFixed(
                                                                      2),
                                                              expenseOrIncome:
                                                                  filteredTransactions[
                                                                          index]
                                                                      .isCredit!,
                                                            )))
                                            : ListView(
                                              reverse: true,
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                children: List.generate(
                                                    (context
                                                                .watch<
                                                                    TransactionProvider>()
                                                                .accountList
                                                                .singleWhere((element) =>
                                                                    element
                                                                        .accountName ==
                                                                    widget
                                                                        .accountModel
                                                                        .accountName)
                                                                .transactions ??
                                                            [])
                                                        .length,
                                                    (index) => SummaryListItem(
                                                          item: context
                                                              .read<
                                                                  TransactionProvider>()
                                                              .accountList
                                                              .singleWhere((element) =>
                                                                  element
                                                                      .accountName ==
                                                                  widget
                                                                      .accountModel
                                                                      .accountName)
                                                              .transactions![
                                                                  index]
                                                              .transactionItem!,
                                                          date: context
                                                              .read<
                                                                  TransactionProvider>()
                                                              .accountList
                                                              .singleWhere((element) =>
                                                                  element
                                                                      .accountName ==
                                                                  widget
                                                                      .accountModel
                                                                      .accountName)
                                                              .transactions![
                                                                  index]
                                                              .date!,
                                                          transactionType: context
                                                              .read<
                                                                  TransactionProvider>()
                                                              .accountList
                                                              .singleWhere((element) =>
                                                                  element
                                                                      .accountName ==
                                                                  widget
                                                                      .accountModel
                                                                      .accountName)
                                                              .transactions![
                                                                  index]
                                                              .isCredit!,
                                                          amount: context
                                                              .read<
                                                                  TransactionProvider>()
                                                              .accountList
                                                              .singleWhere((element) =>
                                                                  element
                                                                      .accountName ==
                                                                  widget
                                                                      .accountModel
                                                                      .accountName)
                                                              .transactions![
                                                                  index]
                                                              .price!
                                                              .toStringAsFixed(
                                                                  2),
                                                          expenseOrIncome: context
                                                              .read<
                                                                  TransactionProvider>()
                                                              .accountList
                                                              .singleWhere((element) =>
                                                                  element
                                                                      .accountName ==
                                                                  widget
                                                                      .accountModel
                                                                      .accountName)
                                                              .transactions![
                                                                  index]
                                                              .isCredit!,
                                                        )))),
                              ),
                              Divider(
                                color: Colors.grey,
                                height: height * 0.05,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.05),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      'Net Total:   GHS ${context.watch<TransactionProvider>().accountList.singleWhere((element) => element.accountName == widget.accountModel.accountName!).remainingBalance.toStringAsFixed(2)}',
                                      style: bodyText1.copyWith(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            ]),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: height * 0.05,
                left: width * 0.05,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => shareImage(),
                      child: CircleAvatar(
                          radius: 25,
                          backgroundColor: primaryColorLight,
                          child: const Icon(Icons.share, color: Colors.white)),
                    ),
                    SizedBox(height: height * 0.02),
                    GestureDetector(
                      onTap: getPdf,
                      child: CircleAvatar(
                          radius: 25,
                          backgroundColor: primaryColorLight,
                          child:
                              const Icon(Icons.save_alt, color: Colors.white)),
                    ),
                  ],
                ),
              )
            ],
          )),
        ));
  }
}

class SummaryListItem extends StatelessWidget {
  final String item, amount, expenseOrIncome, date, transactionType;

  const SummaryListItem({
    Key? key,
    required this.item,
    required this.amount,
    required this.expenseOrIncome,
    required this.date,
    required this.transactionType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(item.toTitleCase(), style: bodyText1)),
          Expanded(child: Text(date, style: bodyText1)),
          Expanded(
              child: Text(transactionType,
                  textAlign: TextAlign.center, style: bodyText1)),
          Expanded(
              child: Text(
                  '${expenseOrIncome == 'credit' ? '+' : "-"}GHS $amount',
                  textAlign: TextAlign.right,
                  style: bodyText1)),
        ],
      ),
    );
  }
}
