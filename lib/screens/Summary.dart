import 'dart:io';

import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:expense_tracker/components/constants.dart';
import 'package:expense_tracker/components/textField-widget.dart';
import 'package:expense_tracker/models/Models.dart';
import 'package:expense_tracker/providers/TransactionProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    setState(() {
      dateRange = newRange;
      fromDate.text = dateRange.start.toString();
      toDate.text = dateRange.end.toString();
    });
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
    String fileName = "TransactionFile";
    if (await Permission.storage.request().isGranted) {
      File pdfFile = File('$tempPath/$fileName.pdf');
      pdfFile.writeAsBytesSync(await pdf.save());
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text("File Saved: $pdfFile"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final difference = dateRange.duration.inDays;
    final List<DateTime> filteredDates =
        List<DateTime>.generate(difference, (index) {
      DateTime date = dateRange.start;

      return date.add(Duration(days: index));
    });

    bool isFiltered() {
      for (int i = 0; i < context
                    .read<TransactionProvider>()
                    .accountList
                    .singleWhere((element) =>
                        element.accountName == widget.accountModel.accountName)
                    .transactions!.length; i++) {
        if (DateFormat.yMMMd().parse(context
                    .read<TransactionProvider>()
                    .accountList
                    .singleWhere((element) =>
                        element.accountName == widget.accountModel.accountName)
                    .transactions![i]
                    .date!).day
                ==
            filteredDates[i].day) {
          return true;
        }
      }
      return false;
    }

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryColor,
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => shareImage(),
              backgroundColor: primaryColorLight,
              child: const Icon(Icons.share, color: Colors.white),
            ),
            SizedBox(height: height * 0.02),
            FloatingActionButton(
              onPressed: getPdf,
              backgroundColor: primaryColorLight,
              child: const Icon(Icons.save_alt, color: Colors.white),
            ),
          ],
        ),
        body: SizedBox(
          height: height,
          width: width,
          child: SafeArea(
              child: Column(
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
                            icon: Icon(Icons.filter_alt, color: Colors.white))),
                    SizedBox(width: width * 0.01),
                    Expanded(
                      child: DateTextField(
                        controller: toDate,
                        color: Colors.white,
                        style: bodyText1,
                        hintText: 'To',
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
                    padding: EdgeInsets.all(width * 0.05),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),
                        color: Colors.white),
                    child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(children: [
                            Image.asset(
                              'assets/app-logo.png',
                              width: width * 0.2,
                            ),
                            SizedBox(height: height * 0.01),
                            Text(widget.accountModel.accountName!.toTitleCase(),
                                style: headline1.copyWith(fontSize: 20))
                          ]),
                          SizedBox(height: height * 0.03),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text('Available Balance',
                                      style: bodyText1.copyWith(
                                          color: Colors.grey)),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('GHS',
                                          style: headline2.copyWith(
                                              color: primaryColor)),
                                      Text(
                                          context
                                              .watch<TransactionProvider>()
                                              .accountList
                                              .singleWhere((element) =>
                                                  element.accountName ==
                                                  widget.accountModel
                                                      .accountName!)
                                              .remainingBalance
                                              .toStringAsFixed(2),
                                          style: headline2.copyWith(
                                              fontSize: 40,
                                              color: primaryColor)),
                                      //Text('.50', style: theme.textTheme.headline2),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('Total Income',
                                          style: bodyText2.copyWith(
                                              color: Colors.grey)),
                                      Text(
                                          '+GHS ${context.watch<TransactionProvider>().accountList.singleWhere((element) => element.accountName == widget.accountModel.accountName!).currentIncome.toStringAsFixed(2)}',
                                          style: bodyText1.copyWith(
                                              fontSize: 17,
                                              color: Colors.green)),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('Expense',
                                          style: bodyText2.copyWith(
                                              color: Colors.grey)),
                                      Text(
                                          '-GHS ${context.watch<TransactionProvider>().accountList.singleWhere((element) => element.accountName == widget.accountModel.accountName!).currentExpense.toStringAsFixed(2)}',
                                          style: bodyText1.copyWith(
                                              fontSize: 17, color: Colors.red)),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: height * 0.05),
                          Row(
                            children: [
                              Expanded(
                                  child: Text('Items',
                                      style: bodyText1.copyWith(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                  child: Text('Amount',
                                      textAlign: TextAlign.right,
                                      style: bodyText1.copyWith(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold))),
                            ],
                          ),
                          Divider(
                            color: Colors.grey,
                            height: height * 0.03,
                          ),
                          SizedBox(
                              // height: height * 0.7,
                              child: (context
                                          .watch<TransactionProvider>()
                                          .accountList
                                          .singleWhere((element) =>
                                              element.accountName ==
                                              widget.accountModel.accountName)
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
                                  : ListView(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      children: List.generate(
                                          isFiltered()
                                              ? filteredDates.length
                                              : (context
                                                      .watch<
                                                          TransactionProvider>()
                                                      .accountList
                                                      .singleWhere((element) =>
                                                          element.accountName ==
                                                          widget.accountModel
                                                              .accountName)
                                                      .transactions ??= [])
                                                  .length,
                                          (index) => SummaryListItem(
                                                item: context
                                                    .read<TransactionProvider>()
                                                    .accountList
                                                    .singleWhere((element) =>
                                                        element.accountName ==
                                                        widget.accountModel
                                                            .accountName)
                                                    .transactions![index]
                                                    .transactionItem!,
                                                amount: context
                                                    .read<TransactionProvider>()
                                                    .accountList
                                                    .singleWhere((element) =>
                                                        element.accountName ==
                                                        widget.accountModel
                                                            .accountName)
                                                    .transactions![index]
                                                    .price!
                                                    .toStringAsFixed(2),
                                                expenseOrIncome: context
                                                    .read<TransactionProvider>()
                                                    .accountList
                                                    .singleWhere((element) =>
                                                        element.accountName ==
                                                        widget.accountModel
                                                            .accountName)
                                                    .transactions![index]
                                                    .isCredit!,
                                              ))))
                        ]),
                  ),
                ),
              )
            ],
          )),
        ));
  }
}

class SummaryListItem extends StatelessWidget {
  final String item, amount, expenseOrIncome;

  const SummaryListItem({
    Key? key,
    required this.item,
    required this.amount,
    required this.expenseOrIncome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(item.toTitleCase(), style: bodyText1)),
          Expanded(
              child: Text(
                  '${expenseOrIncome == 'income' ? '+' : "-"}GHS $amount',
                  textAlign: TextAlign.right,
                  style: bodyText1.copyWith(
                      color: expenseOrIncome == 'income'
                          ? Colors.green
                          : Colors.red))),
        ],
      ),
    );
  }
}
