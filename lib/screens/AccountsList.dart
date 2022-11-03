import 'dart:io';

import 'package:expense_tracker/components/button_widget.dart';
import 'package:expense_tracker/components/constants.dart';
import 'package:expense_tracker/components/notificationButton.dart';
import 'package:expense_tracker/components/textField-widget.dart';
import 'package:expense_tracker/models/Models.dart';
import 'package:expense_tracker/providers/TransactionProvider.dart';
import 'package:expense_tracker/screens/Overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AccountList extends StatelessWidget {
  const AccountList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _backButton(context),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addAccount(context),
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: primaryColor,
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: width * 0.03),
              child: const NotificationIconButton(quantity: 0),
            )
          ],
        ),
        body: SizedBox(
          height: height,
          width: width,
          child: Stack(children: [
            Column(
              children: [
                Container(
                  height: height * 0.3,
                  width: width,
                  color: primaryColor,
                ),
                Expanded(
                  child: Container(color: primaryColorLight),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.1,
                    ),
                    Text("Welcome,",
                        style: headline2.copyWith(
                          color: primaryColorLight,
                          fontSize: 30,
                        )),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    SizedBox(
                      width: width * 0.7,
                      child: Text(
                        "Check your finance status from these list ",
                        style: headline2.copyWith(
                          fontSize: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Expanded(
                      child: context
                              .watch<TransactionProvider>()
                              .accountList
                              .isEmpty
                          ? Center(
                              child: Text(
                                'No Accounts',
                                style: headline1,
                              ),
                            )
                          : ListView(
                              physics: const BouncingScrollPhysics(),
                              children: List.generate(
                                  context
                                      .watch<TransactionProvider>()
                                      .accountList
                                      .length,
                                  (index) => AccountCard(
                                        accountName: context
                                            .watch<TransactionProvider>()
                                            .accountList[index]
                                            .accountName!,
                                        balance:
                                            '${context.watch<TransactionProvider>().accountList[index].balance!}',
                                        onTap: () {
                                          AccountModel accModel = AccountModel(
                                            accountName: context
                                                .read<TransactionProvider>()
                                                .accountList[index]
                                                .accountName!,
                                            balance: context
                                                .read<TransactionProvider>()
                                                .accountList[index]
                                                .balance!,
                                          );
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OverviewScreen(
                                                        accountModel: accModel,
                                                      )));
                                        },
                                      )),
                            ),
                    )
                  ]),
            ),
          ]),
        ),
      ),
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

  _addAccount(context) {
    TextEditingController accountName = TextEditingController();
    TextEditingController balance = TextEditingController();
    var theme = Theme.of(context);
    return showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: SizedBox(
                height: height * 0.35,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Add Account',
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
                      controller: accountName,
                      borderColor: Colors.grey,
                      style: bodyText1,
                      hintText: 'Account Name',
                      prefixIcon: Icon(
                        Icons.credit_card,
                        color: primaryColorLight,
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    CustomTextField(
                      controller: balance,
                      keyboard: TextInputType.number,
                      borderColor: Colors.grey,
                      hintText: 'Balance',
                      style: bodyText1,
                      prefixIcon: Icon(
                        Icons.monetization_on,
                        color: primaryColorLight,
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                Button(
                  onTap: () {
                    AccountModel accountModel = AccountModel(
                        accountName: accountName.text,
                        balance: double.tryParse(balance.text));
                    Provider.of<TransactionProvider>(context, listen: false)
                        .addAccount(accountModel);
                    Navigator.pop(context);
                  },
                  width: width * 0.4,
                  buttonText: 'Add',
                  color: primaryColor,
                )
              ],
            ));
  }
}

class AccountCard extends StatelessWidget {
  final String accountName, balance;
  final Function()? onTap;
  const AccountCard({
    Key? key,
    required this.accountName,
    required this.balance,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: height * 0.02),
      child: ClipRRect(
        //borderRadius: BorderRadius.circular(40),
        child: Container(
          height: height * 0.27,
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
                    radius: 20,
                    backgroundColor: primaryColorLight,
                  )),
              Positioned(
                  height: height * 0.15,
                  right: width * 0.3,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: primaryColorLight,
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(accountName, style: headline2),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Text('Available Balance', style: bodyText2),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('GHS', style: headline2),
                      Text(balance, style: headline2.copyWith(fontSize: 50)),
                      //Text('.50', style: headline2),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Container(
                    width: width * 0.8,
                    //padding: EdgeInsets.symmetric(vertical:height * 0.01),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Color.fromARGB(255, 194, 194, 194)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                        child: Text('Details',
                            textAlign: TextAlign.center,
                            style: headline2.copyWith(fontSize: 18)),
                        onPressed: onTap),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
