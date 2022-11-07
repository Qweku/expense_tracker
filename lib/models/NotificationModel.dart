// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<NotificationModel> notificationModelFromJson(String str) => List<NotificationModel>.from(json.decode(str).map((x) => NotificationModel.fromJson(x)));

String notificationModelToJson(List<NotificationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotificationModel {
    NotificationModel({
        this.title,
        this.body,
        this.date,
        this.time,
    });

    String? title;
    String? body;
    String? date;
    String? time;

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        title: json["title"],
        body: json["body"],
        date: json["date"],
        time: json["time"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
        "date": date,
        "time": time,
    };
}
