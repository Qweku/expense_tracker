// import 'dart:io';
// import 'dart:math';

import 'package:expense_tracker/components/button_widget.dart';
// import 'package:expense_tracker/components/constants.dart';
import 'package:expense_tracker/helper/PdfApi.dart';
import 'package:expense_tracker/models/Models.dart';
import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
import 'package:sizer/sizer.dart';

class PdfViewer extends StatefulWidget {
  final Expense expense;

  const PdfViewer({
    super.key,
    required this.expense,
  });

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    // _generatePdf(context);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Center(
          child: !isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Downloading PDF file...",
                      style: TextStyle(fontSize: 2.h),
                    ),
                    SizedBox(height: 2.h),
                    CircularProgressIndicator(
                      color: theme.colorScheme.inversePrimary,
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save_alt,
                        color: Colors.grey, size: 20.h),
                    SizedBox(
                      height: 1.h,
                    ),
                    Text(
                      "PDF file download",
                      style: TextStyle(fontSize: 2.h),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    SizedBox(
                      height: 7.h,
                      child: Button(
                          color: theme.colorScheme.inversePrimary,
                          width: 40.w,
                          buttonText: "Download PDF",
                          onTap: () {
                            final scaffoldMessenger =
                                ScaffoldMessenger.of(context);

                            PdfExpenseApi.generate(widget.expense).then((_) {
                              isLoading = true;
                              scaffoldMessenger.showSnackBar(const SnackBar(
                                  content: Text("File Saved successfully!")));
                            });
                          }),
                    ),
                  ],
                )),
    );
  }

  // Future<void> _generatePdf(BuildContext context) async {
  //   isLoading = true;
  //   final pdf = pw.Document();

  //   const pageSize = PdfPageFormat.a4;

  //   double margin = 3.w;
  //   final pageHeight = pageSize.height - 2 * margin;
  //   final pageWidth = pageSize.width - 2 * margin;
  //   final lineHeight = 2.h;
  //   final headerHeight = 50.h;

  //   final contentHeight = pageHeight - headerHeight;
  //   final linesPerPage = (contentHeight / lineHeight).floor();
  //   final linesPerRegularPage = (pageHeight / lineHeight).floor();

  //   for (var i = 0;
  //       i < widget.accountModel.transactions!.length;
  //       i += linesPerPage) {
  //     final isFirstPage = i == 0;

  //     final pageItems = (widget.accountModel.transactions ?? [])
  //         .skip(i)
  //         .take(linesPerPage)
  //         .toList();

  //     pdf.addPage(
  //       pw.Page(
  //         pageFormat: pageSize,
  //         build: (context) {
  //           return pw.Column(
  //               //crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 if (isFirstPage)
  //                   pw.Padding(
  //                     padding: pw.EdgeInsets.all(3.w),
  //                     child: pw.Row(
  //                         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           pw.Text(
  //                               widget.accountModel.accountName!.toTitleCase(),
  //                               style: pw.TextStyle(fontSize: 2.h)),
  //                         ]),
  //                   ),
  //                 // SizedBox(height:3.h),
  //                 if (isFirstPage)
  //                   pw.Column(
  //                     crossAxisAlignment: pw.CrossAxisAlignment.center,
  //                     mainAxisAlignment: pw.MainAxisAlignment.center,
  //                     children: [
  //                       pw.Text('Total Balance',
  //                           style:
  //                               pw.TextStyle(fontWeight: pw.FontWeight.bold)),
  //                       pw.Text('GHS ${widget.totalBalance}',
  //                           style: pw.TextStyle(fontSize: 3.h)),
  //                     ],
  //                   ),
  //                 if (isFirstPage) pw.SizedBox(height: 3.h),
  //                 if (isFirstPage)
  //                   pw.Padding(
  //                     padding:
  //                         pw.EdgeInsets.symmetric(horizontal: width * 0.05),
  //                     child: pw.Row(
  //                       crossAxisAlignment: pw.CrossAxisAlignment.end,
  //                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         pw.Expanded(
  //                           child: pw.Text('Transactions',
  //                               style: pw.TextStyle(fontSize: 2.h)),
  //                         ),
  //                         pw.Expanded(
  //                           child: pw.Column(
  //                             crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                             children: [
  //                               pw.Row(
  //                                 mainAxisAlignment:
  //                                     pw.MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   pw.Text('Total Credit:',
  //                                       style: pw.TextStyle(
  //                                           fontWeight: pw.FontWeight.bold)),
  //                                   pw.Text('GHS ${widget.currentIncome}',
  //                                       style: pw.TextStyle(fontSize: 1.2.h)),
  //                                 ],
  //                               ),
  //                               pw.SizedBox(
  //                                 height: height * 0.01,
  //                               ),
  //                               pw.Row(
  //                                 mainAxisAlignment:
  //                                     pw.MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   pw.Text('Total Debit:',
  //                                       style: pw.TextStyle(
  //                                           fontWeight: pw.FontWeight.bold)),
  //                                   pw.Text(
  //                                     'GHS ${widget.currentExpense}',
  //                                     style: pw.TextStyle(fontSize: 1.2.h),
  //                                   )
  //                                 ],
  //                               ),
  //                               pw.SizedBox(
  //                                 height: 1.h,
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 if (isFirstPage) pw.SizedBox(height: 5.h),
  //                 if (isFirstPage)
  //                   pw.Container(
  //                     padding: pw.EdgeInsets.symmetric(
  //                         vertical: 1.h, horizontal: margin),
  //                     // color: pw.Color.fromARGB(255, 197, 196, 196),
  //                     child: pw.Row(
  //                       children: [
  //                         pw.Expanded(
  //                             child: pw.Text('Items',
  //                                 style: pw.TextStyle(
  //                                     fontWeight: pw.FontWeight.bold))),
  //                         pw.Expanded(
  //                             child: pw.Text('Date',
  //                                 style: pw.TextStyle(
  //                                     fontWeight: pw.FontWeight.bold))),
  //                         pw.Expanded(
  //                             child: pw.Text('Transaction Type',
  //                                 style: pw.TextStyle(
  //                                     fontWeight: pw.FontWeight.bold))),
  //                         pw.Expanded(
  //                             child: pw.Text('Amount',
  //                                 textAlign: pw.TextAlign.right,
  //                                 style: pw.TextStyle(
  //                                     fontWeight: pw.FontWeight.bold))),
  //                       ],
  //                     ),
  //                   ),

  //                 pw.SizedBox(
  //                   child: pw.ListView(
  //                       children: pageItems
  //                           .map((item) => pw.Padding(
  //                                 padding: pw.EdgeInsets.only(bottom: 1.h),
  //                                 child: pw.Row(
  //                                   children: [
  //                                     pw.Expanded(
  //                                         child: pw.Text(
  //                                             item.transactionItem!
  //                                                 .toTitleCase(),
  //                                             style: pw.TextStyle(
  //                                                 fontSize: 1.2.h))),
  //                                     pw.Expanded(
  //                                         child: pw.Text(item.date!,
  //                                             style: pw.TextStyle(
  //                                                 fontSize: 1.2.h))),
  //                                     pw.Expanded(
  //                                         child: pw.Text(item.isCredit!,
  //                                             textAlign: pw.TextAlign.center,
  //                                             style: pw.TextStyle(
  //                                                 fontSize: 1.2.h))),
  //                                     pw.Expanded(
  //                                         child: pw.Text(
  //                                             '${item.isCredit == 'credit' ? '+' : "-"}GHS ${item.price}',
  //                                             textAlign: pw.TextAlign.right,
  //                                             style: pw.TextStyle(
  //                                                 fontSize: 1.2.h))),
  //                                   ],
  //                                 ),
  //                               ))
  //                           .toList()),
  //                 ),
  //               ]);
  //         },
  //       ),
  //     );
  //   }

  //   // await Printing.layoutPdf(
  //   //     onLayout: (PdfPageFormat format) async => pdf.save());

  //   int rand = Random().nextInt(1000);
  //   String tempPath = (Directory('/storage/emulated/0/Download')).path;
  //   String fileName = "${widget.accountModel.accountName}_$rand";
  //   // if (await Permission.storage.request().isGranted) {
  //   File pdfFile = File('$tempPath/$fileName.pdf');

  //   pdfFile.writeAsBytes(await pdf.save()).then((value) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   });
  // }
}

class Expense {
  final AccountModel accountModel;
  final String currentExpense, currentIncome, totalBalance;
  const Expense(
      {required this.accountModel,
      required this.currentExpense,
      required this.currentIncome,
      required this.totalBalance});
}
