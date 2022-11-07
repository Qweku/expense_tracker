import 'package:expense_tracker/components/constants.dart';
import 'package:flutter/material.dart';

class BottomSheetChild extends StatelessWidget {
  const BottomSheetChild({
    Key? key,
    required this.theme,
    this.color = Colors.black,
    required this.title,
    this.onTap,
    required this.icon,
  }) : super(key: key);

  final ThemeData theme;
  final Color color;
  final String title;
  final IconData icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColorLight,
            ),
            child:  Icon(icon, color: Colors.white, size: 25),
          ),
          const SizedBox(height: 5),
           Text(title,
              style: theme.textTheme.bodyText2!.copyWith(fontSize: 14)),
        ],
      ),
      onTap: onTap,
    );
  }
}