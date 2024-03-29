
import 'package:expense_tracker/components/constants.dart';

import 'package:expense_tracker/screens/AccountsList.dart';

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
      child: Column(
        children: [
          SizedBox(
            height: height * 0.48,
            child: Image.asset(
              'assets/splash-pic.jpg',
              fit: BoxFit.cover,
              width: width,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(width * 0.05),
              color: primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: height * 0.01),
                  SizedBox(
                    width: width * 0.6,
                    child: Text('Take control of your finances',
                        style: headline2.copyWith(fontSize: 48)),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
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
