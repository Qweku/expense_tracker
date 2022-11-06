// ignore_for_file: prefer_typing_uninitialized_variables, depend_on_referenced_packages

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:timezone/timezone.dart';

import 'package:rxdart/rxdart.dart';

class NotificationPlugin {
  late FlutterLocalNotificationsPlugin notifPlugin;
  final BehaviorSubject<ReceivedNotification>
      didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  late var initializationSettings;

  NotificationPlugin._() {
    init();
  }

  init() async {
    notifPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermission();
    }

    initializePlaformSpecifics();
  }

  initializePlaformSpecifics() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        ReceivedNotification receivedNotification = ReceivedNotification(
            id: id, title: title, body: body, payload: payload);
        didReceiveLocalNotificationSubject.add(receivedNotification);
      },
    );

    initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  }

  _requestIOSPermission() {
    notifPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()!
        .requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  setListenerForLowerVersions(Function onNotificationLower) {
    didReceiveLocalNotificationSubject.listen((receivedNotification) {
      onNotificationLower(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await notifPlugin.initialize(
      initializationSettings,
      //     setOnNotificationClick: (String? payload) async {
      //   onNotificationClick(payload);
      // }
    );
  }

  Future<void> showNotification(String title, String body) async {
    var androidChannelSpecifics = const AndroidNotificationDetails(
        'CHANNEL_ID', 'CHANNEL_NAME',
        importance: Importance.max, priority: Priority.high);

    var iosChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidChannelSpecifics, iOS: iosChannelSpecifics);

    await notifPlugin.show(0, title, body, platformChannelSpecifics,
        payload: 'Test Payload');
  }

  Future<void> scheduleNotification() async {
    var scheduleNotificationDateTime =
        DateTime.now().add(const Duration(milliseconds: 1500));
    var androidChannelSpecifics = const AndroidNotificationDetails(
      'CHANNEL_ID 1',
      'CHANNEL_NAME 1',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      timeoutAfter: 1500,
    );

    var iosChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidChannelSpecifics, iOS: iosChannelSpecifics);

    await notifPlugin.zonedSchedule(0, 'Test Title', 'Test Body',
        scheduleNotificationDateTime as TZDateTime, platformChannelSpecifics,
        payload: 'Test Payload',
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotification {
  final int id;
  final String? title, body, payload;

  ReceivedNotification({
    required this.title,
    required this.body,
    required this.payload,
    required this.id,
  });
}
