

import 'package:flutter/material.dart';

class NotificationIconButton extends StatelessWidget {
  final int quantity;
  final Function()? onTap;
  const NotificationIconButton({Key? key, required this.quantity, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
            onPressed: onTap,
            icon:
                const Icon(Icons.notifications, color: Colors.white, size: 30)),
        Positioned(
            top: height * 0.005,
            left: width * 0.03,
            child: quantity == 0
                ? Container()
                : Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 17, 0),
                        shape: BoxShape.circle),
                    child: Text(
                      '${quantity < 10 ? quantity : '9+'}',
                      style: theme.textTheme.bodyText2!.copyWith(fontSize: 9),
                    ),
                  ))
      ],
    );
  }
}