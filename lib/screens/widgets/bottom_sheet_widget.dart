import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BottomSheetChild extends StatelessWidget {
  const BottomSheetChild({
    super.key,
    required this.theme,
    this.color = Colors.black,
    required this.title,
    this.onTap,
    required this.icon,
  });

  final ThemeData theme;
  final Color color;
  final String title;
  final IconData icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary,
            ),
            child:  Icon(icon, size: 25),
          ),
          const SizedBox(height: 5),
           Text(title,
              style:TextStyle(fontSize: 1.4.h)),
        ],
      ),
    );
  }
}