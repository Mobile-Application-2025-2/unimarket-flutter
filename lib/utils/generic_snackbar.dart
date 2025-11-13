import 'package:flutter/material.dart';

bool _isSnackBarVisible = false;

void genericSnackbar(BuildContext context, String message, Color bgColor, Color textColor) {
  if (_isSnackBarVisible) return;

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

  _isSnackBarVisible = true;

  scaffoldMessenger.showSnackBar(snackBar).closed.then((reason) {
    _isSnackBarVisible = false;
  });
}