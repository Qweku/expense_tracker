import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final double width =
    MediaQueryData.fromView(WidgetsBinding.instance.window).size.width;
final double height =
    MediaQueryData.fromView(WidgetsBinding.instance.window).size.height;

Color primaryColor = Color.fromARGB(255, 8, 112, 55);
Color primaryColorDark = const Color.fromARGB(255, 0, 4, 51);
Color primaryColorLight = Color.fromARGB(255, 247, 150, 6);

TextStyle headline1 = const TextStyle(fontSize: 25, color: Colors.black);
TextStyle headline2 =
    const TextStyle(fontSize: 25, color: Color.fromARGB(255, 255, 255, 255));
TextStyle bodyText1 =
    const TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0));
TextStyle bodyText2 =
    const TextStyle(fontSize: 14, color: Color.fromARGB(255, 255, 255, 255));

int day = DateTime.now().day;
int month = DateTime.now().month;
int year = DateTime.now().year;
int hour = DateTime.now().hour;
int min = DateTime.now().minute;

String currentTime = "$hour:${min < 10 ? "0$min" : "$min"}";

String today = "$day ${months[month - 1]} $year";

DateFormat timeformat = DateFormat.Hm();
DateFormat dateformat = DateFormat.yMd();

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
