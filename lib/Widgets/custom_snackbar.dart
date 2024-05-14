import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show(BuildContext context, String message, {Alignment alignment = Alignment.bottomCenter}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
      backgroundColor: Colors.white10,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
