import 'package:flutter/material.dart';

class MyBotton extends StatelessWidget {
  final void Function()? onTap;
  final String text;

  const MyBotton({
    super.key,
    required this.text, 
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(25)
        ),
        padding: EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 90),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),),
        ),
      ),
    );
  }
}