import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

ThemeData lightMode = ThemeData(
  brightness:  Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade200,
    primary: Colors.grey.shade300,
    tertiary: Colors.grey.shade100,
    secondary: const Color.fromARGB(255, 33, 86, 243),
    inversePrimary: Colors.grey.shade700
  ),
  textTheme: ThemeData.light().textTheme.apply(
    bodyColor: Colors.grey[800],
    displayColor: Colors.black,
     fontFamily: 'Federo',
  ),
  appBarTheme: AppBarTheme(
    foregroundColor: Colors.grey.shade800,
    backgroundColor: Colors.grey.shade300,
    titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 1.7.h,
        fontWeight: FontWeight.w700,
        fontFamily: 'Montserrat'),
  ),
);
