
import 'package:expense_tracker/components/constants.dart';

import 'package:expense_tracker/screens/AccountsList.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/app_Icon.png',
              
              width: 40.w,
            ),
            SizedBox(height: 12.h),
            Text('Take control of your finances',textAlign: TextAlign.center,
                style: TextStyle(fontSize: 4.8.h)),
                SizedBox(height:5.h),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountList()));
              },
              child: Container(
                padding: EdgeInsets.all(width * 0.04),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: theme.colorScheme.secondary),
                child:  Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 3.0.h),
              ),
            )
          ],
        ));
  }
}
