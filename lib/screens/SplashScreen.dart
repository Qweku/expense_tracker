import 'dart:ui';

import 'package:expense_tracker/components/constants.dart';
import 'package:expense_tracker/models/GSheets_API.dart';
import 'package:expense_tracker/screens/AccountsList.dart';
import 'package:expense_tracker/screens/Overview.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
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
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              padding: EdgeInsets.all(width * 0.05),
              height: height,
              width: width,
              color: Colors.white.withOpacity(0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Take control of your finances',
                      style: theme.textTheme.headline1!.copyWith(fontSize: 70)),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OverviewScreen()));
                        print(
                          'Total Sheet = ${GSheetsAPI.numberOfSheets}',
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(width * 0.05),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black),
                        child: const Icon(Icons.arrow_forward_ios,
                            color: Colors.white, size: 30),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
