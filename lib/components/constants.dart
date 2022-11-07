import 'package:flutter/material.dart';

final double width =
    MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
final double height =
    MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;

Color primaryColor = Color.fromARGB(255, 8, 112, 55);
Color primaryColorDark = const Color.fromARGB(255, 0, 4, 51);
Color primaryColorLight = Color.fromARGB(255, 221, 197, 18);

TextStyle headline1 = const TextStyle(fontSize: 25, color: Colors.black);
TextStyle headline2 =
    const TextStyle(fontSize: 25, color: Color.fromARGB(255, 255, 255, 255));
TextStyle bodyText1 =
    const TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0));
TextStyle bodyText2 =
    const TextStyle(fontSize: 14, color: Color.fromARGB(255, 255, 255, 255));

final int day = DateTime.now().day;
final int month = DateTime.now().month;
final int year = DateTime.now().year;
final int hour = DateTime.now().hour;
final int min = DateTime.now().minute;

final String currentTime = "$hour:${min < 10 ? "0$min" : "$min"}";

final String today = "$day ${months[month - 1]} $year";

List<String> months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

extension StringExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
