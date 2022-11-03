// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';


class Button extends StatelessWidget {
  final Function()? onTap;
  final String? buttonText;
  final Color color;
  final Color textColor;
  final double? width;
  final Color borderColor;
  final Color shadowColor;
  const Button({
    Key? key,
    this.onTap,
    this.buttonText,
    this.color = Colors.transparent,
    this.width,
    this.borderColor = Colors.transparent,
    this.shadowColor = Colors.black45,  this.textColor=Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: shadowColor,
              offset: Offset(1, 3),
              blurRadius: 5,
            )
          ],
          color: color,
        ),
        child: Text(
          buttonText!,textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: textColor),
        ),
      ),
    );
  }
}

