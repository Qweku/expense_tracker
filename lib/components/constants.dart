import 'package:flutter/material.dart';

final double width =
    MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
final double height =
    MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.height;

Color primaryColor = const Color.fromARGB(255, 0, 51, 23);
Color primaryColorDark = const Color.fromARGB(255, 0, 4, 51);
Color primaryColorLight = const Color.fromARGB(255, 179, 170, 97);

TextStyle headline1 = const TextStyle(fontSize: 25, color: Colors.black);
TextStyle headline2 = const TextStyle(fontSize: 25, color: Color.fromARGB(255, 255, 255, 255));
TextStyle bodyText1 = const TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0));
TextStyle bodyText2 = const TextStyle(fontSize: 14, color: Color.fromARGB(255, 255, 255, 255));

final int day = DateTime.now().day;
final int month = DateTime.now().month;
final int year = DateTime.now().year;

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
