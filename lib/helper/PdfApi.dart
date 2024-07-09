import 'dart:io';

import 'package:expense_tracker/components/constants.dart';
import 'package:expense_tracker/screens/PDFViewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:sizer/sizer.dart';

class PdfExpenseApi {
  static Future<File> generate(Expense expense) async {
    final pdf = Document();
    pdf.addPage(MultiPage(
        build: (context) => [buildTitle(expense), 
        buildExpense(expense),
        Divider(),
        buildTotal(expense)
        ]));

        await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());

    return PdfApi.saveDocument(
      name: '${expense.accountModel.accountName!} ${DateTime(day).microsecondsSinceEpoch}', 
    pdf: pdf);
  }
}

buildTitle(Expense expense) => pw.Column(
      children: [
        pw.Padding(
          padding: pw.EdgeInsets.all(3.w),
          child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(expense.accountModel.accountName!.toTitleCase(),
                    style: pw.TextStyle(fontSize: 2.h)),
              ]),
        ),
        // SizedBox(height:3.h),

        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text('Total Balance',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('GHS ${expense.totalBalance}',
                style: pw.TextStyle(fontSize: 3.h)),
          ],
        ),
        pw.SizedBox(height: 3.h),

        pw.Padding(
          padding: pw.EdgeInsets.symmetric(horizontal: width * 0.05),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child:
                    pw.Text('Transactions', style: pw.TextStyle(fontSize: 2.h)),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Total Credit:',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text('GHS ${expense.currentIncome}',
                            style: pw.TextStyle(fontSize: 1.2.h)),
                      ],
                    ),
                    pw.SizedBox(
                      height: height * 0.01,
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Total Debit:',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(
                          'GHS ${expense.currentExpense}',
                          style: pw.TextStyle(fontSize: 1.2.h),
                        )
                      ],
                    ),
                    pw.SizedBox(
                      height: 1.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 5.h),

        // pw.Container(
        //   padding: pw.EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
        //   // color: pw.Color.fromARGB(255, 197, 196, 196),
        //   child: pw.Row(
        //     children: [
        //       pw.Expanded(
        //           child: pw.Text('Items',
        //               style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
        //       pw.Expanded(
        //           child: pw.Text('Date',
        //               style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
        //       pw.Expanded(
        //           child: pw.Text('Transaction Type',
        //               style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
        //       pw.Expanded(
        //           child: pw.Text('Amount',
        //               textAlign: pw.TextAlign.right,
        //               style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
        //     ],
        //   ),
        // ),
      ],
    );

buildExpense(Expense expense) {
  final headers = ['Items', 'Date', 'Transaction Type', 'Amount'];
  final data = expense.accountModel.transactions?.map((item) {
    return [item.transactionItem, item.date, item.isCredit, item.price];
  }).toList();
  return Table.fromTextArray(
      headers: headers,
      data: data ?? [],
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 3.h,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
      });
}

buildTotal(Expense expense) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
    child: Align(
      alignment: Alignment.centerRight,
      child: Text(
          'Net Total:  GHS ${expense.currentExpense}',
          //GHS ${context.watch<TransactionProvider>().accountList.singleWhere((element) => element.accountName == widget.accountModel.accountName!).remainingBalance.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
    ),
  );
}

class PdfApi {
  static Future<File> saveDocument(
      {required String name, required pw.Document pdf}) async {
    final directory = await getApplicationDocumentsDirectory();
    final bytes = await pdf.save();
    final file = File('${directory.path}/$name.pdf');
    await file.writeAsBytes(bytes);

    return file;
  }
}
