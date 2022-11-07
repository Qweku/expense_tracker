import 'package:expense_tracker/components/constants.dart';
import 'package:expense_tracker/providers/TransactionProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notificationPlugin.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    notificationPlugin.setListenerForLowerVersions(onNotificationLower);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 238, 238, 238),
        centerTitle: true,
        elevation: 0,
        title: Text('Notifications',
            style: theme.textTheme.headline1!.copyWith(fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, right: 10, left: 10),
        child: SizedBox(
          height: height,
          child: context.watch<TransactionProvider>().notificationList.isEmpty
              ? Center(
                  child: Text(
                    'No Notifications',
                    style: headline1,
                  ),
                )
              : ListView(
                physics: BouncingScrollPhysics(),
                  children: List.generate(
                  context.watch<TransactionProvider>().notificationList.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () async {
                        // await notificationPlugin.showNotification('Bandwidth Warning',
                        //     "Your bandwidth has reached it's max point. Please reduce usage.");
                      },
                      child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white),
                            color: primaryColorLight.withOpacity(0.3),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.notifications,
                                color: primaryColor,
                              ),
                            ),
                            title: Text(
                              context
                                  .read<TransactionProvider>()
                                  .notificationList[index]
                                  .title!,
                              style:
                                  bodyText1.copyWith(color: primaryColor,fontSize: 17),
                            ),
                            subtitle: Text(
                                context
                                    .read<TransactionProvider>()
                                    .notificationList[index]
                                    .body!.toCapitalized(),
                                style: bodyText1),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                               context
                                    .read<TransactionProvider>()
                                    .notificationList[index]
                                    .date!,
                              style: bodyText1.copyWith(color: primaryColor),
                            ),
                                Text(
                                   context
                                    .read<TransactionProvider>()
                                    .notificationList[index]
                                    .time!,
                                  style:
                                      bodyText1.copyWith(color: primaryColor),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                )),
        ),
      ),
    );
  }

  onNotificationLower(ReceivedNotification receivedNotification) {}
  onNotificationClick(String payload) {
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return NotificationScreen();
    // }));
  }
}
