import 'package:flutter/material.dart';

void showInfoSnackbar(BuildContext context) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  scaffoldMessenger.hideCurrentSnackBar();

  final snackBar = SnackBar(
    content: Text(
      "¡Esta funcionalidad aún no está disponible!",
      style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.blue,
    duration: Duration(milliseconds: 700),
    behavior: SnackBarBehavior.floating,
  );

  scaffoldMessenger.showSnackBar(snackBar);
}