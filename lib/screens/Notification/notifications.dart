import 'package:expense_tracker/components/constants.dart';
import 'package:expense_tracker/providers/TransactionProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'notificationPlugin.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      controller.animateTo(controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 10), curve: Curves.easeInOut);
    });
    notificationPlugin.setListenerForLowerVersions(onNotificationLower);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
         centerTitle: true,
        elevation: 0,
        title: const Text('Notifications',
           ),
      ),
      body: Padding(
          padding:  EdgeInsets.only(top: 3.0.h, right: 2.w, left: 2.w),
          child: SizedBox(
              height: height,
              child: context
                      .watch<TransactionProvider>()
                      .notificationList
                      .isEmpty
                  ? Center(
                      child: Text(
                        'No Notifications',
                        style: headline1,
                      ),
                    )
                  : SingleChildScrollView(
                    controller: controller,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: List.generate(
                            context
                                .watch<TransactionProvider>()
                                .notificationList
                                .length, (index) {
                          return Padding(
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
                                    //border: Border.all(color: Colors.white),
                                    color: theme.colorScheme.primary,
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: theme.colorScheme.background,
                                      child: Icon(
                                        Icons.notifications,
                                        color: theme.colorScheme.tertiary,
                                      ),
                                    ),
                                    title: Text(
                                      context
                                          .read<TransactionProvider>()
                                          .notificationList[index]
                                          .title!,
                                      style: TextStyle(
                                          fontSize: 1.7.h),
                                    ),
                                    subtitle: Text(
                                        context
                                            .read<TransactionProvider>()
                                            .notificationList[index]
                                            .body!,
                                        ),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          context
                                              .watch<TransactionProvider>()
                                              .notificationList[index]
                                              .date!,
                                          
                                        ),
                                        Text(
                                          context
                                              .watch<TransactionProvider>()
                                              .notificationList[index]
                                              .time!,
                                         
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          );
                        }

                            //reverse: true,

                            ),
                      ),
                    ))),
    );
  }

  onNotificationLower(ReceivedNotification receivedNotification) {}
  onNotificationClick(String payload) {
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return NotificationScreen();
    // }));
  }
}
