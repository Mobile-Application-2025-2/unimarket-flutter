import 'package:flutter/material.dart';

void genericSnackbar(BuildContext context, String message, Color bgColor, Color textColor) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  scaffoldMessenger.hideCurrentSnackBar();

  final snackBar = SnackBar(
    content: Text(
      message,
      style: TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.w500),
      textAlign: TextAlign.center,
    ),
    backgroundColor: bgColor,
    duration: Duration(seconds: 1),
    behavior: SnackBarBehavior.floating,
  );

  scaffoldMessenger.showSnackBar(snackBar);
}