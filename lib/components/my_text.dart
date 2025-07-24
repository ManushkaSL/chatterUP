import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final Color? fillColor; // optional fill color

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.tertiary),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.primary),
            borderRadius: BorderRadius.circular(15),
          ),
          fillColor: fillColor ?? colorScheme.secondary,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: colorScheme.primary),
        ),
        style: TextStyle(color: colorScheme.onSurface),
      ),
    );
  }
}
