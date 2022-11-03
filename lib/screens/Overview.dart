import 'dart:io';
import 'dart:ui';

import 'package:expense_tracker/components/button_widget.dart';
import 'package:expense_tracker/components/constants.dart';
import 'package:expense_tracker/models/Models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/textField-widget.dart';

class OverviewScreen extends StatelessWidget {
  AccountModel accountModel;
   OverviewScreen({super.key,required this.accountModel});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addExpense(context),
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: theme.primaryColor,
        ),
        body: SizedBox(
          height: height,
          width: width,
          child: Stack(
            children: [
              Image.asset(
                'assets/splash.gif',
                fit: BoxFit.cover,
                height: height,
                width: width,
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  color: Colors.white.withOpacity(0.9),
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
                              style: theme.textTheme.headline1!
                                  .copyWith(color: Colors.grey)),
                          Text(
                            "Account Name",
                            style: theme.textTheme.headline1!.copyWith(
                              fontSize: 30,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),
                          BalanceCard(theme: theme),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: width * 0.05),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Activity',
                              style: theme.textTheme.headline1!
                                  .copyWith(color: Colors.grey),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Divider(
                          color: const Color.fromARGB(255, 224, 224, 224),
                          height: height * 0.03,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.01),
                          children: List.generate(
                              7,
                              (index) => Padding(
                                    padding:
                                        EdgeInsets.only(bottom: height * 0.01),
                                    child: Container(
                                      padding: EdgeInsets.all(width * 0.01),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border:
                                              Border.all(color: Colors.white),
                                          color: //theme.primaryColorLight
                                              Colors.white.withOpacity(0.5)),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.arrow_downward,
                                            color: theme.primaryColorLight,
                                          ),
                                        ),
                                        title: Text('Food',
                                            style: theme.textTheme.headline1!
                                                .copyWith(fontSize: 17)),
                                        subtitle: Text(today,
                                            style: theme.textTheme.headline1!
                                                .copyWith(
                                                    color: Colors.grey,
                                                    fontSize: 12)),
                                        trailing: Text('-GHS 20.00',
                                            style: theme.textTheme.bodyText1!
                                                .copyWith(
                                                    color: theme
                                                        .primaryColorLight)),
                                      ),
                                    ),
                                  )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  _addExpense(context) {
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
                    Text('Add Expense',
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
                      keyboard: TextInputType.number,
                      borderColor: Colors.grey,
                      hintText: 'Amout',
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
                  width: width * 0.4,
                  buttonText: 'Add',
                  color: primaryColor,
                )
              ],
            ));
  }
}

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Container(
        height: height * 0.2,
        width: width * 0.9,
        decoration: BoxDecoration(color: theme.primaryColor),
        child: Stack(
          children: [
            Positioned(
                top: -height * 0.02,
                left: -width * 0.05,
                child: CircleAvatar(
                    radius: 60, backgroundColor: theme.primaryColorLight)),
            Positioned(
                bottom: -height * 0.02,
                right: -width * 0.05,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: theme.primaryColorLight,
                )),
            Positioned(
                bottom: height * 0.02,
                left: width * 0.05,
                child: CircleAvatar(
                  //radius: 0,
                  backgroundColor: Colors.black,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.add, color: Colors.white),
                  ),
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Available Balance', style: theme.textTheme.bodyText2),
                SizedBox(
                  height: height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('GHS', style: theme.textTheme.headline2),
                    Text('2,030',
                        style:
                            theme.textTheme.headline2!.copyWith(fontSize: 60)),
                    Text('.50', style: theme.textTheme.headline2),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
