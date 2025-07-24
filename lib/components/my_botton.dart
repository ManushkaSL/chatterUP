import 'package:flutter/material.dart';

class MyBotton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final Color? backgroundColor; // optional background color
  final Color? textColor; // optional text color

  const MyBotton({
    super.key,
    required this.text,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? colorScheme.secondary,
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 50),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor ?? colorScheme.onSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
