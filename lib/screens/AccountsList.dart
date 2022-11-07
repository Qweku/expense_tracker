// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:expense_tracker/components/button_widget.dart';
import 'package:expense_tracker/components/constants.dart';
import 'package:expense_tracker/components/notificationButton.dart';
import 'package:expense_tracker/components/textField-widget.dart';
import 'package:expense_tracker/models/GSheets_API.dart';
import 'package:expense_tracker/models/Models.dart';
import 'package:expense_tracker/models/NotificationModel.dart';
import 'package:expense_tracker/providers/TransactionProvider.dart';
import 'package:expense_tracker/screens/Notification/notificationPlugin.dart';
import 'package:expense_tracker/screens/Notification/notifications.dart';
import 'package:expense_tracker/screens/Overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

class AccountList extends StatefulWidget {
  const AccountList({
    Key? key,
  }) : super(key: key);

  @override
  State<AccountList> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  TextEditingController accountName = TextEditingController();
  TextEditingController balance = TextEditingController();
  LocalStorage storage = LocalStorage('accounts');
  _addAccount() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return showDialog<bool>(
        barrierDismissible: false,
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
                  onTap: () async {
                    AccountModel accountModel = AccountModel(
                        accountName: accountName.text,
                        balance: double.tryParse(balance.text));
                    Provider.of<TransactionProvider>(context, listen: false)
                        .addAccount(accountModel);
                    NotificationModel notiModel = NotificationModel(
                              title: "New Account",
                              body:
                                  ("${accountModel.accountName} created successfully.").toCapitalized());
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
                        

                    await storage.setItem(
                        'accountList',
                        accountModelToJson(Provider.of<TransactionProvider>(
                                context,
                                listen: false)
                            .accountList));
                    accountName.clear();
                    balance.clear();
                    Navigator.pop(context);
                  },
                  width: width * 0.4,
                  buttonText: 'Add',
                  color: primaryColor,
                )
              ],
            ));
  }

  onNotificationLower(ReceivedNotification receivedNotification) {}
  onNotificationClick(String payload) {
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return NotificationScreen();
    // }));
  }

  void bootUp() async {
    if (await storage.ready) {
      Provider.of<TransactionProvider>(context, listen: false).accountList =
          accountModelFromJson(storage.getItem('accountList') ?? '[]');
      Provider.of<TransactionProvider>(context, listen: false)
              .notificationList =
          notificationModelFromJson(storage.getItem('notifList') ?? '[]');
    } else {
      _addAccount();
    }
  }

  @override
  void initState() {
    notificationPlugin.setListenerForLowerVersions(onNotificationLower);
    notificationPlugin.setOnNotificationClick(onNotificationClick);

    // _addAccount();
    bootUp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _backButton(context),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addAccount(),
          backgroundColor: primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: width * 0.03),
              child: NotificationIconButton(
                quantity: context.watch<TransactionProvider>().notiCount,
                onTap: () {
                  if (context.read<TransactionProvider>().notiCount > 0) {
                    context.read<TransactionProvider>().notiCount = 0;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationScreen()));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationScreen()));
                  }
                },
              ),
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
                                        balance: context
                                            .watch<TransactionProvider>()
                                            .accountList[index]
                                            .remainingBalance
                                            .toStringAsFixed(2),
                                        onTap: () {
                                          AccountModel accModel = AccountModel(
                                            accountName: context
                                                .read<TransactionProvider>()
                                                .accountList[index]
                                                .accountName!,
                                            balance: context
                                                .read<TransactionProvider>()
                                                .accountList[index]
                                                .remainingBalance,
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
                  Text(accountName.toTitleCase(), style: headline2),
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
                      border: Border.all(
                          color: const Color.fromARGB(255, 194, 194, 194)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                        onPressed: onTap,
                        child: Text('Details',
                            textAlign: TextAlign.center,
                            style: headline2.copyWith(fontSize: 18))),
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
