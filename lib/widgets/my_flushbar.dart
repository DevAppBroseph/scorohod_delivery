import 'package:another_flushbar/flushbar.dart';
import 'package:delivery/services/constants.dart';
import 'package:flutter/material.dart';

class MyFlushbar {
  static void showFlushbar(BuildContext context, String title, String message) {
    Flushbar(
      margin: const EdgeInsets.only(left: 15, right: 15),
      borderRadius: radius,
      title: title,
      message: message,
      duration: const Duration(seconds: 3),
    ).show(context);
  }
}
